/**
 * @file core.h
 *
 * This file contains tools (such as file reading), useful for many elements of the program.
 */

#ifndef CORE_H
#define CORE_H

#include <stddef.h>

/**
 * Returned by ::readfile_callback to continue reading the file. If this is returned after the null
 * terminator, ::readfile will fail.
 */
#define READFILE_CALLBACK_CONTINUE 0
/** Returned by ::readfile_callback to stop reading the file, as no more data is needed */
#define READFILE_CALLBACK_STOP     1
/** Returned by ::readfile_callback to stop reading the file, because an error was found */
#define READFILE_CALLBACK_ERROR    2

/**
 * @typedef readfile_callback
 * @brief Function called by ::readfile to process a new buffer
 *
 * @param data  Data read from the file
 * @param size  Size of the @p data buffer
 * @param state File handler's (usually a parser) state, kept from callback to callback
 *
 * @returns See ::READFILE_CALLBACK_CONTINUE, ::READFILE_CALLBACK_STOP and
 *              ::READFILE_CALLBACK_ERROR
 */
typedef int(*readfile_callback)(char *data, size_t size, void *state);

/**
 * @brief Reads a text file, calling a callback function to feed it new data.
 *
 * The data provided to the callback function will be null-terminated.
 *
 * @param cb       Function to be called with parts of the file data
 * @param cb_state Initial state passed to the callback
 * @param fp       File path
 *
 * @returns 0 on success, 1 on error
 */
int readfile(readfile_callback cb, void *cb_state, const char *fp);

#endif
