#include <stdio.h>
#include <time.h>
#include <display.h>

void display_begin(void) {
	fputs("{ \"version\":1 }\n[", stdout);
}

/**
 * @def USAGE_COLOR(val, med, bad)
 * @brief The color for presenting a value, given medium and bad color thresholds
 * @hideinitializer
 *
 * @param val      Value that will be displayed
 * @param med, bad Thresholds that change the color of the value to ::COLOR_MEDIUM and ::COLOR_BAD
 *
 * @return Color to be used for displaying the value
 */
#define USAGE_COLOR(val, med, bad) ((val) < (med)) ? COLOR_OK : \
                                   (((val) < (bad)) ? COLOR_MEDIUM : COLOR_BAD )

void display_cpu(cpu_display_data *c) {
	const char *separator_params = "\"separator\": false, \"separator_block_width\": 0";

	printf(", { \"full_text\": \"%.1f %%\", %s, \"color\": \"%s\" }"
	       ", { \"full_text\": \" @ \", %s }"
	       ", { \"full_text\": \"%.2f ºC\", \"color\": \"%s\" }",

		c->usage * 100, separator_params,
		USAGE_COLOR(c->usage, CPU_USAGE_MEDIUM_THRESHOLD, CPU_USAGE_BAD_THRESHOLD),
		separator_params,
		c->temp, USAGE_COLOR(c->temp, CPU_TEMP_MEDIUM_THRESHOLD, CPU_TEMP_BAD_THRESHOLD)
	);
} /**< @brief Internal function for displaying CPU usage on the `swaybar` */

/**
 * @brief Internal function that outputs a string with the used memory, using an adequate unit
 *
 * @param[in]  used     Used memory in KiB
 * @param[out] out      Pointer to the output string
 * @param[in]  out_size Maximum number of bytes that can be written to the output
 */
void display_mem_fancy_string(size_t used, char *out, size_t out_size) {
	if (used < 1024) {
		snprintf(out, out_size, "%zu KiB", used);
	} else if (used < 1024 * 1024) {
		snprintf(out, out_size, "%.0f MiB", ((float) used) / 1024);
	} else {
		snprintf(out, out_size, "%.2f GiB", ((float) used) / (1024 * 1024));
	}
}

void display_mem(mem_display_data *m) {
	char str[128];
	display_mem_fancy_string(m->mem_used, str, 128);

	printf(", { \"color\": \"%s\", \"full_text\": \"%s",
		USAGE_COLOR(m->mem_used, MEM_MEDIUM_THRESHOLD, MEM_BAD_THRESHOLD), str);

	/* If swap is being used, use two distinct blocks that seem like only one */
	if (m->swap_used > 0) {
		display_mem_fancy_string(m->swap_used, str, 128);
	printf(" \", \"separator\": false, \"separator_block_width\": 0 }, "
		       "{ \"color\": \""COLOR_BAD"\", \"full_text\": \"(swapping %s)", str);
	}

	fputs("\" }", stdout);
} /**< Internal function for displaying memory usage on the `swaybar` */

void display_time(time_display_data *t) {
	/* HH:MM:SS DD/MM/YY */
	printf(", { \"full_text\" :\"%02d:%02d:%02d %02d/%02d/%02d\" }",
		t->tm_hour, t->tm_min, t->tm_sec,
		t->tm_mday, t->tm_mon + 1, t->tm_year % 100);
} /**< Internal function for displaying time on the `swaybar` */

void display_update(display_data *data) {
	printf("[{}"); /* Empty object will be ignored and makes comma placement uniform */

	display_cpu (&data->cpu);
	display_mem (&data->mem);
	display_time(&data->time);

	printf("],\n");
	fflush(stdout);
}
