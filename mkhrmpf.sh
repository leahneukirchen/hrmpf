#!/bin/bash

: "${VERSION:=$(date -u +%Y%m%d)}"
IFS=$'\n' extra_args=( $(xargs -n1 <<< "$EXTRA_ARGS") )

while getopts a: FLAG; do
	case "$FLAG" in
		a) ARCH="$OPTARG" ;;
		*) exit 1 ;;
	esac
done

shift $((OPTIND - 1))

if [ -z "$ARCH" ]; then
    if command -v xbps-uhelper >/dev/null 2>&1; then
        ARCH="$(xbps-uhelper arch)"
    else
        ARCH="$(uname -m)"
    fi
fi

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
cat << 'EOF' >> hrmpf-include/etc/skel/.bash_profile
[ -f $HOME/.bashrc ] && . $HOME/.bashrc
EOF
cp hrmpf-include/etc/skel/.bash_profile hrmpf-include/root/.bash_profile
cat << 'EOF' >> hrmpf-include/etc/skel/.bashrc
[[ $- != *i* ]] && return
PROMPT_COMMAND='history -a'
PROMPT_DIRTRIM=2
PS1='[\u@\h \w]\$ '
EOF
cp hrmpf-include/etc/skel/.bashrc hrmpf-include/root/.bashrc
mkdir -p hrmpf-include/etc/sysctl.d
touch hrmpf-include/etc/sysctl.d/10-void-user.conf

case "$ARCH" in
	x86_64*)
		mkdir -p hrmpf-include/usr/bin
		sed "s/@@MKLIVE_VERSION@@/$(date -u +%Y%m%d)/g" < installer.sh > hrmpf-include/usr/bin/void-installer
		chmod 0755 hrmpf-include/usr/bin/void-installer

		extra_args+=(
			-s "xz -Xbcj x86"
			-B extra/balder10.img
			-B extra/mhdd32ver4.6.iso
			-B extra/ipxe.iso
			-B extra/memtest86+-7.20.iso
			-B extra/grub2.iso
		)
		;;
	aarch64*)
		mkdir -p hrmpf-include/usr/bin
		printf "#!/bin/sh\necho 'void-installer is not supported on this live image'\n" > hrmpf-include/usr/bin/void-installer
		chmod 0755 hrmpf-include/usr/bin/void-installer
		extra_args+=(
			-s "xz -Xbcj arm"
		)
		;;
esac

case "$ARCH" in
	aarch64*)
		extra_args+=(
			-r https://repo-default.voidlinux.org/current/aarch64/nonfree
		)
		;;
	*-musl)
		extra_args+=(
			-r https://repo-default.voidlinux.org/current/musl/nonfree
		)
		;;
	*)
		extra_args+=(
			-r https://repo-default.voidlinux.org/current/nonfree
		)
		;;
esac

./mklive.sh \
	-T "hrmpf live/rescue system" \
	-C "loglevel=6 printk.time=1 consoleblank=0 net.ifnames=0" \
	-F 2048 \
	-i zstd \
	-p "$(grep -hs '^[^#].' hrmpf.packages "hrmpf.${ARCH%-musl}.packages")" \
	-A "gawk tnftp inetutils-hostname libressl-netcat dash vim-common" \
	-S "acpid binfmt-support dhcpcd gpm sshd" \
	-I hrmpf-include \
	-o "hrmpf-${ARCH}-${VERSION}.iso" \
	-a "${ARCH}" \
	"${extra_args[@]}" \
	"$@"
