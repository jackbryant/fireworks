TARGETS = mountkernfs.sh fake-hwclock hostname.sh udev keyboard-setup mountdevsubfs.sh console-setup mountall.sh mountall-bootclean.sh mountnfs.sh mountnfs-bootclean.sh networking alsa-utils urandom checkroot.sh x11-common kbd procps mtab.sh bootmisc.sh udev-mtab kmod checkroot-bootclean.sh plymouth-log checkfs.sh
INTERACTIVE = udev keyboard-setup console-setup checkroot.sh kbd checkfs.sh
udev: mountkernfs.sh
keyboard-setup: mountkernfs.sh udev
mountdevsubfs.sh: mountkernfs.sh udev
console-setup: mountall.sh mountall-bootclean.sh mountnfs.sh mountnfs-bootclean.sh kbd
mountall.sh: checkfs.sh checkroot-bootclean.sh
mountall-bootclean.sh: mountall.sh
mountnfs.sh: mountall.sh mountall-bootclean.sh networking
mountnfs-bootclean.sh: mountall.sh mountall-bootclean.sh mountnfs.sh
networking: mountkernfs.sh mountall.sh mountall-bootclean.sh urandom
alsa-utils: mountall.sh mountall-bootclean.sh mountnfs.sh mountnfs-bootclean.sh
urandom: mountall.sh mountall-bootclean.sh
checkroot.sh: fake-hwclock keyboard-setup mountdevsubfs.sh hostname.sh
x11-common: mountall.sh mountall-bootclean.sh mountnfs.sh mountnfs-bootclean.sh
kbd: mountall.sh mountall-bootclean.sh mountnfs.sh mountnfs-bootclean.sh
procps: mountkernfs.sh mountall.sh mountall-bootclean.sh udev
mtab.sh: checkroot.sh
bootmisc.sh: mountall-bootclean.sh mountall.sh mountnfs.sh mountnfs-bootclean.sh udev checkroot-bootclean.sh
udev-mtab: udev mountall.sh mountall-bootclean.sh
kmod: checkroot.sh
checkroot-bootclean.sh: checkroot.sh
plymouth-log: mountall.sh mountall-bootclean.sh mountnfs.sh mountnfs-bootclean.sh
checkfs.sh: checkroot.sh mtab.sh
