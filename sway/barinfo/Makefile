CC = gcc
CFLAGS = -Wall

OBJDIR   := obj
BUILDDIR := build
DOCSDIR  := docs

SOURCES = $(wildcard src/*.c)
HEADERS = $(wildcard include/*.h)
OBJECTS = $(patsubst src/%.c, $(OBJDIR)/%.o, $(wildcard src/*.c))

default: $(BUILDDIR)/barinfo

$(OBJDIR)/%.o: src/%.c $(HEADERS)
	@mkdir -p $(OBJDIR)
	${CC} -c -o $@ $< ${CFLAGS} -Iinclude

$(BUILDDIR)/barinfo: $(OBJECTS)
	@mkdir -p $(BUILDDIR)
	$(CC) -o $@ $^



define Doxyfile

INPUT = include src
RECURSIVE = YES
EXTRACT_ALL = YES
FILE_PATTERNS = *.h *.c

PROJECT_NAME = barinfo
INPUT += README.md
USE_MDFILE_AS_MAINPAGE=README.md

OUTPUT_DIRECTORY = $(DOCSDIR)

GENERATE_HTML  = YES
GENERATE_LATEX = NO

endef
export Doxyfile

$(DOCSDIR): $(SOURCES) $(HEADERS)
	echo "$$Doxyfile" | doxygen -

clean:
	@rm -r $(OBJDIR)   > /dev/null 2>&1 ||:
	@rm -r $(BUILDDIR) > /dev/null 2>&1 ||:
	@rm -r $(DOCSDIR)  > /dev/null 2>&1 ||:
