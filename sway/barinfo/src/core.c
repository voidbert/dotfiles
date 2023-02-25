#include <stdio.h>
#include <core.h>

#define BUFFER_SIZE 4096

int readfile(readfile_callback cb, void *cb_state, const char *fp) {
	char data[BUFFER_SIZE];

	FILE* f = fopen(fp, "r");
	if (f == NULL) {
		return 1;
	}

	size_t read_bytes;
	while ((read_bytes = fread(data, 1, BUFFER_SIZE, f)) == BUFFER_SIZE) {

		int cb_result = cb(data, read_bytes, cb_state);
		switch (cb_result) {
			case READFILE_CALLBACK_CONTINUE:
				break;
			case READFILE_CALLBACK_STOP:
				fclose(f);
				return 0;
			case READFILE_CALLBACK_ERROR:
				fclose(f);
				return 1;
		}
	}

	if (!feof(f)) {
		fclose(f);
		return 1;
	} else {
		/*
		 * Will not segfault. If the file has BUFFER_SIZE bytes, the last buffer will be empty.
		 */
		data[read_bytes] = '\0';
		int cb_result = cb(data, read_bytes + 1, cb_state);
		switch (cb_result) {
			case READFILE_CALLBACK_CONTINUE:
				/* Cannot continue when the file has ended */
				fclose(f);
				return 1;
			case READFILE_CALLBACK_STOP:
				fclose(f);
				return 0;
			case READFILE_CALLBACK_ERROR:
				fclose(f);
				return 1;
		}
	}

	if (fclose(f) != 0) {
		return 1;
	}

	return 0;
}
