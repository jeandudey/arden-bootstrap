/*
 * SPDX-FileCopyrightText: 2022 Samuel Tyler <samuel@samuelt.me>
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

/* From live-bootstrap's steps/gzip-1.2.4/files/stat_override.c, without the
   syscall headers it includes: they are not used, and the x86 one is not there
   on other architectures.  */

#include <sys/stat.h>

int _stat(const char *path, struct stat *buf) {
	int rc = stat(path, buf);
	if (rc == 0) {
		buf->st_atime = 0;
		buf->st_mtime = 0;
	}
	return rc;
}

int _lstat(const char *path, struct stat *buf) {
	int rc = lstat(path, buf);
	if (rc == 0) {
		buf->st_atime = 0;
		buf->st_mtime = 0;
	}
	return rc;
}

#define stat(a,b) _stat(a,b)
#define lstat(a,b) _lstat(a,b)
