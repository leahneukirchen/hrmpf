#!/bin/sh

./mklive.sh \
	-T "hrmpf live/rescue system" \
	-C "loglevel=6 printk.time=1 net.ifnames=0" \
	-r http://repo.voidlinux.eu/current \
	-r http://repo.voidlinux.eu/current/nonfree \
	-S 1024 \
	-B extra/balder10.img \
	-B extra/mhdd32ver4.6.iso \
	-B extra/ipxe.iso \
	-B extra/memtest86+-5.01.iso \
	-p "$(grep '^[^#].' hrmpf.packages)" \
	-U "spl zfs"
