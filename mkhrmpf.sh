#!/bin/sh

rm -rf hrmpf-include

# Create an empty zpool.cache to prevent importing at boot
mkdir -p hrmpf-include/etc/zfs
: > hrmpf-include/etc/zfs/zpool.cache

mkdir -p hrmpf-include/etc/runit/runsvdir/default
ln -s /etc/sv/nanoklogd hrmpf-include/etc/runit/runsvdir/default/
ln -s /etc/sv/socklog-unix hrmpf-include/etc/runit/runsvdir/default/socklog-unix
mkdir -p hrmpf-include/etc/sv/socklog-unix/log
printf '%s\n' '#!/bin/sh' 'exec svlogd -ttt /var/log/socklog/* 2>/dev/tty12' > hrmpf-include/etc/sv/socklog-unix/log/run
chmod +x hrmpf-include/etc/sv/socklog-unix/log/run
mkdir -p hrmpf-include/var/log/socklog/tty12
printf '%s\n' '-*' 'e*' 'Eauth.*' 'Eauthpriv.*' > hrmpf-include/var/log/socklog/tty12/config
mkdir -p hrmpf-include/etc/skel hrmpf-include/root
touch hrmpf-include/etc/skel/.vimrc hrmpf-include/root/.vimrc

./mklive.sh \
	-T "hrmpf live/rescue system" \
	-C "loglevel=6 printk.time=1 consoleblank=0 net.ifnames=0" \
	-r https://repo-default.voidlinux.org/current \
	-r https://repo-default.voidlinux.org/current/nonfree \
	-F 2048 \
	-i zstd \
	-s "xz -Xbcj x86" \
	-B extra/balder10.img \
	-B extra/mhdd32ver4.6.iso \
	-B extra/ipxe.iso \
	-B extra/memtest86+-5.01.iso \
	-B extra/grub2.iso \
	-p "$(grep '^[^#].' hrmpf.packages)" \
	-A "gawk tnftp inetutils-hostname libressl-netcat dash vim-common" \
	-S "acpid binfmt-support dhcpcd gpm sshd" \
	-I hrmpf-include \
	"$@"
