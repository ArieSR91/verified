#!/bin/bash -e
cd ${HOME}
## termux-exec sets LD_PRELOAD so let's unset it before continuing
unset LD_PRELOAD
## Workaround for Libreoffice, also needs to bind a fake /proc/version

## Default user is "Arie-SR91"
user="Arie-SR91"
home="/home/$user"
start="sudo -u Arie-SR91 /bin/bash"

## NH can be launched as root with the "-r" cmd attribute
## Also check if user kali exists, if not start as root
if grep -q "Arie-SR91" kali/etc/passwd; then
    KALIUSR="1";
else
    KALIUSR="0";
fi
if [[ $KALIUSR == "0" || ("$#" != "0" && ("$1" == "-r" || "$1" == "-R")) ]];then
    user="root"
    home="/$user"
    start="/bin/bash --login"
    if [[ "$#" != "0" && ("$1" == "-r" || "$1" == "-R") ]];then
        shift
    fi
fi

cmdline="proot \
        --link2symlink \
        -0 \
        -r kali \
        -b /dev \
        -b /sys \
        -b /proc \
        -b /system \
        -b kali$home:/dev/shm \
        -w $home \
           /usr/bin/env -i \
           HOME=$home \
           TERM=$TERM \
           $start"

cmd="$@"
if [ "$#" == "0" ];then
    exec $cmdline
else
    $cmdline -c "$cmd"
fi
