kind: manual
(@): elements/gcc/tools-new.yml

description: |
  OpenSSL 3.6.0, built by gcc 4.7.4 as static libraries, with every pregenerated file taken out and made again by its own scripts, and generic 64 bit code.

build-depends:
  (>):
  - linux-headers/linux-headers-4.14.341.bst
  - perl/perl-5.42.0.bst

sources:
- kind: tar
  url: "github:openssl/openssl/releases/download/openssl-3.6.0/openssl-3.6.0.tar.gz"
  ref: b6a5f44b7eb69e3fa35dbf15524405b44837a481d43d81daddde3ff21fcbb8e9

variables:
  lb: "%{libdir}/live-bootstrap/openssl-3.6.0"

config:
  configure-commands:
  - |
    chmod -R u+w .
    patch -Np1 -i %{lb}/patches/copyright-year-reproducible.patch
    patch -Np1 -i %{lb}/patches/missing-files.patch
    rm apps/*.{pem,crt}
    find demos -name "*.pem" -delete
    rm crypto/asn1/charmap.h \
        crypto/bn/bn_prime.h \
        crypto/conf/conf_def.h \
        crypto/ec/ecp_sm2p256_table.c \
        crypto/ec/ecp_nistz256_table.c \
        crypto/objects/obj_dat.h \
        crypto/objects/obj_xref.h
    mv crypto/kdf/kdf_err{,.bak}.c
    mv include/openssl/kdferr.h include/openssl/kdferr.h.bak
    rm crypto/*/?*err.c \
        crypto/*err.c \
        crypto/sslerr.h \
        engines/*_err.{c,h} \
        include/{openssl,internal,crypto}/?*err.h \
        providers/common/include/prov/proverr.h \
        providers/common/provider_err.c
    mv crypto/kdf/kdf_err{.bak,}.c
    mv include/openssl/kdferr.h.bak include/openssl/kdferr.h
    rm external/perl/Text-Template-1.56/Makefile.PL \
        external/perl/Text-Template-1.56/MANIFEST \
        external/perl/Text-Template-1.56/t/author-signature.t \
        external/perl/Text-Template-1.56/t/author-pod-syntax.t
    rm fuzz/oids.txt
    find test \( -name "*.pem" \
        -o -name "*.tlssct" \
        -o -name "*.csr" \
        -o -name "*.key" \
        -o -name "*.p12" \
        -o -name "*.der" \
        -o -name "*.dat" \
        -o -name "*.crt" \
        -o -name "*.cms" \) -delete
    rm test/recipes/25-test_pkcs7_data/grfc.out \
        test/recipes/30-test_evp_data/evpmac_siphash.txt \
        test/recipes/80-test_cmp_http_data/test_connection.csv \
        test/recipes/80-test_tsa_data/all-zero.tsq \
        test/recipes/80-test_tsa_data/sectigo-all-zero.tsr \
        test/recipes/90-test_store_data/testrsa.msb \
        test/recipes/90-test_threads_data/store/8489a545.0 \
        test/recipes/90-test_store.t \
        test/shibboleth.pfx
    rm test/bn_rand_range.h \
        test/*.bin \
        test/evp_extra_test2.c \
        test/evp_pkey_provided_test.c
    rm doc/designs/quic-design/images/quic-overview.odg \
        doc/life-cycles/lifecycles.ods
    ./Configure --prefix="%{prefix}" \
        --libdir="%{libdir}" \
        no-shared no-module no-tests no-docs linux-generic64
  build-commands:
  - |
    declare -x SOURCE_DATE_EPOCH=1759320660
    declare -x OSSL_COPYRIGHT_YEAR=2025
    make generate
    perl util/mkerr.pl -internal -rebuild
    for conf in engines/*.ec; do
        c_file="$(basename "$conf" .ec).c"
        perl util/mkerr.pl -conf "$conf" -rebuild "engines/$c_file"
    done
    mv ./*_err.{c,h} engines/
    make
  install-commands:
  - |
    make -f Makefile install PREFIX=%{prefix} DESTDIR=%{install-root}
    rm -r "%{install-root}%{prefix}/ssl/misc"
