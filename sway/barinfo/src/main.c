#include <stdio.h>
#include <time.h>
#include <unistd.h>

#include <display.h>
#include <date.h>

int main() {
	display_data data = {
		.cpu = { .usage = 0.6f, .temp = 180 /* Meanwhile in Pentium IV land */ },
		.mem = { .mem_used = 3000, .swap_used = 0 },
		.error = NULL
	};

	display_begin();

	for (;;) {
		date_update_display_data(&data);

		display_update(&data);
		sleep(1);
	}

	return 0;
}
