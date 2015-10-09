#!/bin/sh
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

type getarg >/dev/null 2>&1 || . /lib/dracut-lib.sh

SERVICEDIR=$NEWROOT/etc/sv
SERVICES="$(getarg live.services)"

for f in ${SERVICES}; do
        ln -sf /etc/sv/$f $NEWROOT/etc/runit/runsvdir/default/
done

for f in acpid dhcpcd gpm sshd udevd; do
        ln -sf /etc/sv/$f $NEWROOT/etc/runit/runsvdir/default/
done
