/**
 * @file cpu.h
 *
 * This file exposes functions for getting CPU usage information.
 */

#ifndef CPU_H
#define CPU_H

#include <inttypes.h>

#include <time.h>
#include <display.h>

/**
 * @struct cpu_usage_status
 * @brief State needed to calculate CPU usage.
 *
 * @var cpu_usage_status::last_time
 *   When `/proc/file` was read the last time.
 * @var cpu_usage_status::last_idle
 *   Last idle CPU time read from `/proc/stat`.
 *
 * @var cpu_usage_status::nproc
 *   `sysconf(_SC_NPROCESSORS_CONF)`. The number of total cores. This won't adapt to enabled
 *   / disabled cores.
 * @var cpu_usage_status::clk_tck
 *   `sysconf(_SC_CLK_TCK)`.
 */
typedef struct {
	struct timespec last_time;
	uint64_t  last_idle;

	long nproc;
	long clk_tck;

} cpu_usage_status;

/**
 * @brief Gets initial information to allow for CPU usage information.
 * @returns 0 on success, 1 on failure.
 */
int cpu_initial_state(cpu_usage_status *out);


/**
 * @brief Changes the CPU usage in the information to be displayed
 *
 * @param status Previous ::cpu_usage_status. It's contents will be changed for the next call.
 * @param data   Display data that will be modified
 */
void cpu_update_display_data(cpu_usage_status *status, display_data *data);

#endif
