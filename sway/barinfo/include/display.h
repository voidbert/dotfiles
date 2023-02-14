/**
 * @file display.h
 *
 * This header file is used to output data to `stdout` using the `swaybar` JSON-based protocol.
 * For more information, see:
 *
 * ```bash
 * $ man 7 swaybar-protocol
 * ```
 */

#ifndef DISPLAY_H
#define DISPLAY_H

#define COLOR_OK     "#FFFFFF"
#define COLOR_MEDIUM "#FFFF00"
#define COLOR_BAD    "#FF0000"

#define CPU_USAGE_MEDIUM_THRESHOLD 0.4f
#define CPU_USAGE_BAD_THRESHOLD    0.75f

#define CPU_TEMP_MEDIUM_THRESHOLD 50
#define CPU_TEMP_BAD_THRESHOLD    70

#define MEM_MEDIUM_THRESHOLD (3 * 1024 * 1024) /* 3 GiB */
#define MEM_BAD_THRESHOLD    (6 * 1024 * 1024) /* 6 GiB */

#include <time.h>

/**
 * @struct cpu_display_data
 * @brief Information about the CPU to be displayed
 *
 * @var cpu_display_data::usage
 *   CPU usage from 0.0 to 1.0
 * @var cpu_display_data::temp
 *   CPU temperature in Celcius
 */
typedef struct {
	float usage;
	float temp;
} cpu_display_data;

/**
 * @struct mem_display_data
 * @brief Information about memory usage to be displayed
 *
 * @var mem_display_data::mem_used
 *   Used memory in KiB
 * @var mem_display_data::swap_used
 *   Used swap space in KiB
 */
typedef struct {
	size_t mem_used;
	size_t swap_used;
} mem_display_data;

/**
 * @typedef time_display_data
 * @brief Current time and date to be displayed
 */
typedef struct tm time_display_data;

/**
 * @struct display_data
 * @brief Totality of information to be displayed on the `swaybar`
 *
 * @var display_data::error
 *   A pointer to a string with an error message. Cannot contain quotes. NULL for no error.
 */
typedef struct {
	cpu_display_data  cpu;
	mem_display_data  mem;
	time_display_data time;

	const char *error;
} display_data;

void display_begin(void); /**< Begins outputting the `swaybar` json file to `stdout` */

void display_update(const display_data *data); /**< Updates the `swaybar` with new data */

#endif
