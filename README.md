     _                    __ 
    | |_  _ _ _ __  _ __ / _|
    | ' \| '_| '  \| '_ \  _|
    |_||_|_| |_|_|_| .__/_|    version 0.1.90  "Kiasoachbomba"
                   |_|       

Welcome to the hrmpf rescue system, built on Void Linux.
This project is based on void-mklive.

#### Dependencies

* xbps>=0.45
* GNU bash

#### Features

* Loads of console standard tools, with a focus on:
   * system rescue
   * maintainance
   * diagnosis
   * networking
   * security
   * ad-hoc setups
   * tiny bits of entertainment if you have to wait for something

* Missing software easily installable via XBPS.

* Non-Linux extra images (only via ISOLINUX):
   * memtest86+
   * iPXE
   * FreeDOS
   * MHDD32 hard disk analysis

* ISO image can be burned on CD or written raw on USB stick.

* Load to RAM option, also bootable as MEMDISK.

* A plain Bash as default shell without annoying fancy configuration.

#### Usage

To build your own:

    % ./mkhrmpf.sh
    % linux32 ./mkhrmpf.sh

Download pre-built images at
<https://github.com/chneukirchen/hrmpf/releases>.

