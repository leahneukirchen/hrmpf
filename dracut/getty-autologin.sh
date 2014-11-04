#!/bin/sh
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

type getarg >/dev/null 2>&1 || . /lib/dracut-lib.sh

USERNAME=$(getarg live.user)
[ -z "$USERNAME" ] && USERNAME=anon

printf '%s\n' '#!/bin/sh' "exec setsid agetty --noclear --autologin root /dev/tty1 38400 linux" >${NEWROOT}/etc/sv/agetty-tty1/run
printf '%s\n' '#!/bin/sh' "exec setsid agetty --autologin root --login-pause /dev/\${PWD##*-} 38400 linux" >${NEWROOT}/etc/sv/agetty-generic/run
