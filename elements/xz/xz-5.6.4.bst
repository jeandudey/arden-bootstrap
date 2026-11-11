kind: manual
(@): elements/gcc/tools-new.yml

description: |
  xz 5.6.4, built by gcc 4.7.4 as static libraries, with the tables that came with it made again by programs built from its own sources, and the test files that are archives left out.

build-depends:
  (>):
  - autoconf/autoconf-2.71.bst
  - automake/automake-1.16.3.bst
  - perl/perl-5.42.0.bst

sources:
- kind: tar
  url: "github:tukaani-project/xz/releases/download/v5.6.4/xz-5.6.4.tar.bz2"
  ref: 176d510c30d80a23b8050bbc048f2ecaacb823ae48b6821727ed6591f0df9200

variables:
  lb: "%{libdir}/live-bootstrap/xz-5.6.4"

config:
  configure-commands:
  - |
    chmod -R u+w .
    rm po/*.gmo
    rm -rf po4a/man
    rm tests/files/*.{x,l}z
    rm src/liblzma/rangecoder/price_table.c src/liblzma/lzma/fastpos_table.c \
        src/liblzma/lz/lz_encoder_hash_table.h \
        src/liblzma/check/crc{32,64}_table_*.h
    pushd src/liblzma/rangecoder
    gcc -std=c99 -o price_tablegen price_tablegen.c
    ./price_tablegen > price_table.c
    popd
    pushd src/liblzma/lzma
    gcc -std=c99 -o fastpos_tablegen fastpos_tablegen.c
    ./fastpos_tablegen > fastpos_table.c
    popd
    pushd src/liblzma/check
    gcc -std=c99 -o crc32_tablegen_le crc32_tablegen.c
    ./crc32_tablegen_le > crc32_table_le.h
    gcc -std=c99 -DWORDS_BIGENDIAN -o crc32_tablegen_be crc32_tablegen.c
    ./crc32_tablegen_be > crc32_table_be.h
    gcc -std=c99 -DLZ_HASH_TABLE -o crc32_tablegen_hashtable crc32_tablegen.c
    ./crc32_tablegen_hashtable > ../lz/lz_encoder_hash_table.h
    gcc -std=c99 -o crc64_tablegen_le crc64_tablegen.c
    ./crc64_tablegen_le > crc64_table_le.h
    gcc -std=c99 -DWORDS_BIGENDIAN -o crc64_tablegen_be crc64_tablegen.c
    ./crc64_tablegen_be > crc64_table_be.h
    popd
    AUTOMAKE=automake-1.15 ACLOCAL=aclocal-1.15 AUTOCONF=autoconf-2.69 AUTOM4TE=autom4te-2.69 autoreconf-2.69 -f
    ./configure \
        --prefix="%{prefix}" \
        --disable-shared \
        --disable-nls \
        --build="%{triple-musl}" \
        --libdir="%{libdir}"
  build-commands:
  - |
    make
  install-commands:
  - |
    make -f Makefile install PREFIX=%{prefix} DESTDIR=%{install-root}
