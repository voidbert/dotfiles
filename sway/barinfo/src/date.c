#include <display.h>
#include <time.h>

time_display_data *date_get_info(void) {
	time_t unixt = time(NULL);
	if (unixt == -1) {
		return NULL;
	}
	return localtime(&unixt);
}

void date_update_display_data(display_data *data) {
	time_display_data *date = date_get_info();
	if (date) {
		data->time = *date;
	} else {
		data->error = "Failed to get time / date information";
	}
}
