#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <display.h>

int main() {
	time_t unix_time = 0;
	struct tm *time = localtime(&unix_time);

	display_data data = {
		.cpu = { .usage = 0.6f, .temp = 180 /* Meanwhile in Pentium IV land */ },
		.mem = { .mem_used = 3000, .swap_used = 10 },
		.time = *time
	};

	display_begin();

	for (;;) {
		display_update(&data);
		sleep(1);
	}

	return 0;
}
