/* Without lstat, the glob code tests that a name exists with test_eaccess,
   which fails for F_OK unless the user is root. */
#define HAVE_LSTAT 1
