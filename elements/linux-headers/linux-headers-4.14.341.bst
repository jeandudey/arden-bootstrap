kind: manual
(@): elements/gcc/tools-new.yml

description: |
  The user space headers of Linux 4.14, from the 4.14.336 sources with the
  patch live-bootstrap has for 4.14.341, made by the scripts of the kernel with
  unifdef built from its sources, and the system call numbers made for 32 and
  64 bits.  The headers that live-bootstrap leaves out are left out.

sources:
- kind: tar
  url: "kernel-cdn:pub/linux/kernel/v4.x/linux-4.14.336.tar.xz"
  ref: 0820fdb7971c6974338081c11fbf2dc869870501e7bdcac4d0ed58ba1f57b61c

variables:
  lb: "%{libdir}/live-bootstrap/linux-headers-4.14.341-openela"
  inc: "%{install-root}%{prefix}/include"

config:
  configure-commands:
  - |
    chmod -R u+w .
    for p in %{lb}/patches/*.patch; do patch -Np1 -i $p; done
    rm include/uapi/linux/pktcdvd.h \
      include/uapi/linux/hw_breakpoint.h \
      include/uapi/linux/eventpoll.h \
      include/uapi/linux/atmdev.h \
      include/uapi/asm-generic/fcntl.h \
      arch/x86/include/uapi/asm/mman.h \
      arch/x86/include/uapi/asm/auxvec.h
  build-commands:
  - gcc -o scripts/unifdef scripts/unifdef.c
  install-commands:
  - |
    base_dir=$PWD
    mkdir -p %{inc}
    for d in include/uapi arch/x86/include/uapi; do
      cd $d
      find . -type d -exec mkdir -p %{inc}/{} \;
      headers=$(find . -type f -name "*.h")
      cd $base_dir
      for h in $headers; do
        path=$(dirname $h)
        scripts/headers_install.sh %{inc}/$path $d/$path $(basename $h)
      done
    done
    for i in types ioctl termios termbits ioctls sockios socket param; do
      cp %{inc}/asm-generic/$i.h %{inc}/asm/$i.h
    done
    sh arch/x86/entry/syscalls/syscallhdr.sh arch/x86/entry/syscalls/syscall_32.tbl \
      %{inc}/asm/unistd_32.h i386
    sh arch/x86/entry/syscalls/syscallhdr.sh arch/x86/entry/syscalls/syscall_64.tbl \
      %{inc}/asm/unistd_64.h common,64
    sh arch/x86/entry/syscalls/syscallhdr.sh arch/x86/entry/syscalls/syscall_64.tbl \
      %{inc}/asm/unistd_x32.h common,x32 "" __X32_SYSCALL_BIT
    echo '#define LINUX_VERSION_CODE 266064' > %{inc}/linux/version.h
    echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + ((c) > 255 ? 255 : (c)))' \
      >> %{inc}/linux/version.h
