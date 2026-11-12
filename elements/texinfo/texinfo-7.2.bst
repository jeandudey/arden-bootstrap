kind: manual
(@):
- elements/gcc/tools-new.yml
- elements/gnulib/unicode-16.0.0.yml

description: |
  texinfo 7.2, built by gcc 4.7.4 with the files that are generated made again:
  the language tables by its own script, from the ISO 639-2 and country code
  lists fetched as sources, and the gnulib Unicode tables by its generator.

build-depends:
  (>):
  - autoconf/autoconf-2.71.bst
  - automake/automake-1.16.3.bst
  - gettext/gettext-0.26.bst
  - gzip/gzip.bst
  - help2man/help2man-1.36.4.bst
  - libtool/libtool-2.4.7.bst
  - libunistring/libunistring-1.4.1.bst
  - musl/musl-1.2.5.bst
  - perl/perl-5.42.0.bst
  - perl/perl-Text-CSV-2.06.bst

sources:
  (>):
  - kind: tar
    url: "kernel-mirror:gnu/texinfo/texinfo-7.2.tar.xz"
    ref: 0329d7788fbef113fa82cb80889ca197a344ce0df7646fe000974c5d714363a6
    directory: texinfo-7.2
  - kind: tar
    url: "github:coreutils/gnulib/archive/d82702e.tar.gz"
    ref: 6c88fbb32da7446c48774143583d03a70bf9615d43f22d1ee66cfe0d4028563d
    directory: gnulib-d82702e
  - kind: remote
    url: "https://www.loc.gov/standards/iso639-2/ISO-639-2_utf-8.txt"
    ref: 42b71885e4dc885559fda5ad059fd81838cf4782cedb5fd08cc3431f7d067371
    filename: ISO-639-2_utf-8.txt
  - kind: remote
    url: "https://raw.githubusercontent.com/datasets/country-codes/1991017dfce2e8cdea0c1d6f20341bd0f9baa225/data/country-codes.csv"
    ref: bc34b498d87dfaadc10a2fa52e38dacc72a16fbc9ae477a294450667fa8abf49
    filename: country-codes.csv

variables:
  lb: "%{libdir}/live-bootstrap/texinfo-7.2"
  command-subdir: texinfo-7.2

config:
  configure-commands:
  - |
    chmod -R u+w ..
    patch -d .. -Np0 -i %{lb}/patches/documentlanguages_no_download.patch
    find . \( -name '*.mo' -o -name '*.gmo' -o -name '*.pdf' \) -delete
    rm man/{info,install-info,makeinfo,pod2texi,texi2dvi,texindex}.1
    rm tp/Texinfo/XS/convert/converters_options.{c,h} \
        tp/Texinfo/XS/convert/cmd_converter.c \
        tp/Texinfo/XS/main/{cmd,global,options}_* \
        tp/Texinfo/XS/main/{element_types,html_conversion_data}.{c,h} \
        tp/Texinfo/XS/main/{accent_tables_8bit_codepoints.c,command_data.c,command_ids.h} \
        tp/Texinfo/Documentlanguages.pm \
        tp/maintain/lib/libintl-perl/{gettext_xs,}/Makefile \
        tp/maintain/lib/{Text-Unidecode,libintl-perl}/META.json \
        tp/maintain/template.pod
    touch tp/Texinfo/XS/main/command_{ids.h,data.c} \
        tp/Texinfo/XS/main/global_{multi,unique}_commands_case.c \
        tp/Texinfo/XS/main/global_commands_types.h
    rm -r tp/t/results \
        tp/tests/test_scripts \
        tp/tests/*/res_parser \
        tp/tests/many_input_files/*_res \
        install-info/tests/ii-*-file*
    for f in \
        tp/Texinfo/{Commands,Options,HTMLData}.pm \
        tp/Texinfo/Convert/{Info,DocBook,Plaintext,TexinfoXML,HTML}.pm; do
      sed '/^__END__$/q' "$f" > "$f.new"
      mv "$f.new" "$f"
    done
    grep generated tp/maintain/lib/libintl-perl/lib/Locale/RecodeData/*.pm -l | xargs rm
    (cd tp
    mv ../../ISO-639-2_utf-8.txt ../../country-codes.csv maintain/
    perl maintain/regenerate_documentlanguages-loc.pl)
    sed 's#$(realpath \(\.\./gnulib-d82702e\))#$(cd \1 \&\& pwd)#' %{lb}/import-gnulib.sh > ../import-gnulib.sh
    bash ../import-gnulib.sh
    export AUTOMAKE=automake-1.16 ACLOCAL=aclocal-1.16
    autoreconf -fi
    (cd tp/Texinfo/XS
    autoreconf -fi)
    ./configure --prefix=%{prefix}
  build-commands:
  - make
  install-commands:
  - make DESTDIR=%{install-root} install
