     _                    __ 
    | |_  _ _ _ __  _ __ / _|
    | ' \| '_| '  \| '_ \  _|
    |_||_|_| |_|_|_| .__/_|
                   |_|       

Welcome to the hrmpf rescue system, built on Void Linux.
This project is based on void-mklive.

#### Dependencies

* xbps
* GNU bash

#### Features

* Loads of console standard tools, with a focus on:
   * system rescue
   * maintenance
   * diagnosis
   * networking
   * security
   * ad-hoc setups
   * ZFS support
   * tiny bits of entertainment if you have to wait for something

* memtest86+

* Missing software easily installable via XBPS.

* Non-Linux extra images (only via ISOLINUX):
   * iPXE
   * FreeDOS
   * MHDD32 hard disk analysis
   * Bare GRUB 2

* ISO image can be burned on CD or written raw on USB stick.

* Load to RAM option, also bootable as MEMDISK or via netboot.xyz.

* A plain Bash as default shell without annoying fancy configuration.

#### Minimum requirements

* x86_64 CPU
* 512 MB RAM

#### Usage

To build your own:

    % sudo ./mkhrmpf.sh

Download pre-built images at
<https://github.com/leahneukirchen/hrmpf/releases>.

