# This Makefile will build the MinGW Win32 application.
# Make (GNU Make) Tutorial: https://www.gnu.org/software/make/manual/make.html

HEADERS = include/callbacks.h include/resource.h
OBJS =	obj/winmain.o obj/callbacks.o obj/resource.o
INCLUDE_DIRS = -I.\include

WARNS = -Wall

CC = gcc
LDFLAGS = -s -lcomctl32 -Wl,--subsystem,windows
RC = windres

# Compile ANSI build only if CHARSET=ANSI
ifeq (${CHARSET}, ANSI)
  CFLAGS = -O3 -std=c99 -D _WIN32_IE=0x0500 -D WINVER=0x500 ${WARNS}
else
  CFLAGS = -O3 -std=c99 -D UNICODE -D _UNICODE -D _WIN32_IE=0x0500 -D WINVER=0x500 ${WARNS}
endif


all: Win32App.exe

Win32App.exe: ${OBJS}
	${CC} -o "$@" ${OBJS} ${LDFLAGS}

clean:
	del obj\*.o "Win32App.exe"

obj:
	mkdir obj

obj/%.o: src/%.c ${HEADERS} obj
	${CC} ${CFLAGS} ${INCLUDE_DIRS} -c $< -o $@

obj/resource.o: res/resource.rc res/Application.manifest res/Application.ico include/resource.h
	${RC} -I.\include -I.\res -i $< -o $@


# Notes on options and switches:

# _WIN32_IE:  specifying which minimum version of Win32 OS and IE that are
# required for running your application. By increasing the requirements, the
# include files will allow you to access more advanced features, but of course
# your application will not run on older operating systems (such as Win95,
# Win98, NT 3.51 or similar) or the application will require DLL files installed
# with recent IE versions to be able to display new child controls or similar.
