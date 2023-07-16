#include <time.h>
#include <unistd.h>

#include <core.h>
#include <cpu.h>
#include <display.h>

/** The parser is looking for the `"\ncpu "` string. See cpu_parser_state::step */
#define CPU_PARSER_BEFORE_CPU     1

/**
 * The parser found the `"\ncpu "` string and is looking for the value of time spent idling. See
 * cpu_parser_state::step
 */
#define CPU_PARSER_AFTER_CPU      2

/** The parser is reading the time the CPU spent idling. See cpu_parser_state::step */
#define CPU_PARSER_READING_NUMBER 3

/**
 * @struct cpu_parser_state
 * @brief  Data kept from buffer to buffer, in order to find needed CPU data in /proc/stat.
 *
 * @var cpu_parser_state::step
 *   Current task of the parser. See ::CPU_PARSER_BEFORE_CPU, ::CPU_PARSER_AFTER_CPU and
 *   ::CPU_PARSER_READING_NUMBER
 *
 * @var cpu_parser_state::cpu_string_count
 *   While looking for the `"\ncpu "` string, this will be the number of characters left to
 *   complete the string. For example, if the last characters were a newline, c and p, this
 *   variable will be `2`. If this value is `-1`, then the `"\ncpu"` wasn't found on this line (a
 *   character broke the match).
 *
 * @var cpu_parser_state::last_was_space
 *   If the previous character was a space, while running the ::CPU_PARSER_AFTER_CPU step.
 *
 * @var cpu_parser_state::space_count
 *   The number of contiguous spaces counted until the current character.
 *
 * @var cpu_parser_state::cpu_time
 *   Time spent idling by the CPU. Will contain a temporary value during
 *   ::CPU_PARSER_READING_NUMBER.
 */
typedef struct {
	int step;

	/* For CPU_PARSER_BEFORE_CPU */
	int cpu_string_count;

	/* For CPU_PARSER_AFTER_CPU */
	int last_was_space;
	int space_count;

	/* For CPU_PARSER_READING_NUMBER */
	uint64_t cpu_time;
} cpu_parser_state;

const cpu_parser_state default_state = {
	.step             = CPU_PARSER_BEFORE_CPU,
	.cpu_string_count = 4, /* Fake the file starting on '\n' for code simplicity */
	.last_was_space   = 0,
	.space_count      = 0,
	.cpu_time         = 0
}; /**< Initial value for a `/proc/stat` parser */

void proc_stat_find_idle  (cpu_parser_state *state, char c);
int  proc_stat_read_number(cpu_parser_state *state, char c);

/**
 * @brief Looks for the `"\ncpu "` string while parsing `/proc/stat` (see ::parse_proc_stat_info)
 *
 * When its last character is found, the parser step is updated to ::CPU_PARSER_AFTER_CPU and
 * ::proc_stat_find_idle is called to process the last space in `"\ncpu "`.
 */
void proc_stat_find_cpu(cpu_parser_state *state, char c) {
	if (state->cpu_string_count != -1 && state->cpu_string_count <= 5) {
		if (c == "\ncpu "[5 - state->cpu_string_count]) {
			state->cpu_string_count--;
		} else {
			state->cpu_string_count = -1;
		}

		if (state->cpu_string_count == 0) { /* CPU string found */
			state->step = CPU_PARSER_AFTER_CPU;
			proc_stat_find_idle(state, c);
		}
	}
}

/**
 * @brief Looks for the 4th number in the `/proc/stat` cpu line, correspondent to the time spent
 *        idling. See ::parse_proc_stat_info.
 *
 * When its first character is found, The parser step is updated to ::CPU_PARSER_READING_NUMBER and
 * the first character of the number is processed by ::proc_stat_read_number.
 */
void proc_stat_find_idle(cpu_parser_state *state, char c) {
	if (c == ' ') {
		state->space_count += !state->last_was_space;
		state->last_was_space = 1;
	} else {
		if (state->space_count == 4) {
			state->step = CPU_PARSER_READING_NUMBER;
			proc_stat_read_number(state, c);
		}

		state->last_was_space = 0;
	}
}


/**
 * @brief Reads the number in `/proc/stat` corresponding to the time spend idling by the CPU.
 *        See ::parse_proc_stat_info.
 * @returns 0 if the current character is a digit, 1 if it is not.
 */
int proc_stat_read_number(cpu_parser_state *state, char c) {
	if ('0' <= c && c <= '9') {
		state->cpu_time = state->cpu_time * 10 + (c - '0');
		return 0;
	}
	return 1;
}

/** Helper function for ::cpu_idle_time that analyses data read from `/proc/stat`. */
int parse_proc_stat_info(char *data, size_t size, void *s) {
	cpu_parser_state *state = (cpu_parser_state *) s;

	for (size_t i = 0; i < size; ++i) {
		if (data[i] == '\n') {
			switch (state->step) {
				case CPU_PARSER_BEFORE_CPU:
					state->cpu_string_count = 5;
					break;
				case CPU_PARSER_AFTER_CPU: /* No idle number found */
					return READFILE_CALLBACK_ERROR;
				case CPU_PARSER_READING_NUMBER: /* Stop reading idle number */
					return READFILE_CALLBACK_STOP;
				default:
					break;
			}
		}

		switch (state->step) {
			case CPU_PARSER_BEFORE_CPU:
				proc_stat_find_cpu(state, data[i]);
				break;
			case CPU_PARSER_AFTER_CPU:
				proc_stat_find_idle(state, data[i]);
				break;
			case CPU_PARSER_READING_NUMBER:
				if (proc_stat_read_number(state, data[i]))
					return READFILE_CALLBACK_STOP;
				break;
			default:
				break;
		}

		if (data[i] == '\0') {
			/* End of file should never be reached. CPU data be returned first. */
			return READFILE_CALLBACK_ERROR;
		}
	}

	return READFILE_CALLBACK_CONTINUE;
}

/**
 * @brief Read `/proc/stat` to get the time the CPU spent idling.
 * @returns 0 on failure, the CPU's idle time on success.
 */
size_t cpu_idle_time(void) {
	cpu_parser_state state = default_state;
	int result = readfile(parse_proc_stat_info, &state, "/proc/stat");
	if (result)
		return 0;
	return state.cpu_time;
}

int cpu_initial_state(cpu_usage_status *out) {
	out->nproc   = sysconf(_SC_NPROCESSORS_CONF);
	out->clk_tck = sysconf(_SC_CLK_TCK);
	int err      = clock_gettime(CLOCK_MONOTONIC, &out->last_time);
	if (out->nproc == -1 || out->clk_tck == -1 || err == -1)
		return 1;

	out->last_idle = cpu_idle_time();
	if (out->nproc == 0)
		return 1;

	return 0;
}

void cpu_update_display_data(cpu_usage_status *status, display_data *data) {
	struct timespec time;
	int err = clock_gettime(CLOCK_MONOTONIC, &time);
	if (err == -1 || status->nproc == -1) {
		data->error = "Failed to get CPU usage information";
		return;
	}

	size_t idle = cpu_idle_time();
	if (idle == 0) {
		data->error = "Failed to get CPU usage information";
		return;
	}

	uint64_t elapsed /* in ns */ = ((time.tv_sec  - status->last_time.tv_sec) * 10e9L +
	                               (time.tv_nsec - status->last_time.tv_nsec)) * status->nproc;
	uint64_t delta_idle = (idle - status->last_idle) * (10e9L / status->clk_tck);
	data->cpu.usage = (float) (elapsed - delta_idle) / (float) elapsed;

	status->last_time = time;
	status->last_idle = idle;
}

