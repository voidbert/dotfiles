#include <time.h>
#include <display.h>

#ifndef DATE_H
#define DATE_H

/** Gets the current date.
 *
 * @returns
 *   A pointer to static memory (the same as ::localtime), NULL in case of error.
 */
time_display_data *date_get_info(void);

/** Changes the date in the information to be displayed */
void date_update_display_data(display_data *data);

#endif
