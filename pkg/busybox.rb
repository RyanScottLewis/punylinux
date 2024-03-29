name      :busybox
version   '1.31.0'
archive   "https://busybox.net/downloads/busybox-#{version}.tar.bz2"
signature "#{archive}.sig"
checksum  "#{archive}.sha256"

on_build do |package|
  config_path = package.build_path.join('.config')

  unless config_path.exist?
    cd(package.build_path) { make :defconfig }

    update_config(package.build_path.join('.config'),
      'CONFIG_PREFIX'  => %Q["#{paths.os_root.expand_path}"], # Install location
      'CONFIG_STATIC'  => ?y,                                 # Statically link libraries
      'CONFIG_LINUXRC' => ?n,                                 # Do not build linuxrc file
    )
  end

  cd(package.build_path) { make }
end

on_install do |package|
  cd(package.build_path) { make :install }
end

files %w(
  /bin/arch
  /bin/ash
  /bin/base64
  /bin/busybox
  /bin/cat
  /bin/chattr
  /bin/chgrp
  /bin/chmod
  /bin/chown
  /bin/conspy
  /bin/cp
  /bin/cpio
  /bin/cttyhack
  /bin/date
  /bin/dd
  /bin/df
  /bin/dmesg
  /bin/dnsdomainname
  /bin/dumpkmap
  /bin/echo
  /bin/ed
  /bin/egrep
  /bin/false
  /bin/fatattr
  /bin/fdflush
  /bin/fgrep
  /bin/fsync
  /bin/getopt
  /bin/grep
  /bin/gunzip
  /bin/gzip
  /bin/hostname
  /bin/hush
  /bin/ionice
  /bin/iostat
  /bin/ipcalc
  /bin/kbd_mode
  /bin/kill
  /bin/link
  /bin/linux32
  /bin/linux64
  /bin/ln
  /bin/login
  /bin/ls
  /bin/lsattr
  /bin/lzop
  /bin/makemime
  /bin/mkdir
  /bin/mknod
  /bin/mktemp
  /bin/more
  /bin/mount
  /bin/mountpoint
  /bin/mpstat
  /bin/mt
  /bin/mv
  /bin/netstat
  /bin/nice
  /bin/nuke
  /bin/pidof
  /bin/ping
  /bin/ping6
  /bin/pipe_progress
  /bin/printenv
  /bin/ps
  /bin/pwd
  /bin/reformime
  /bin/resume
  /bin/rev
  /bin/rm
  /bin/rmdir
  /bin/rpm
  /bin/run-parts
  /bin/scriptreplay
  /bin/sed
  /bin/setarch
  /bin/setpriv
  /bin/setserial
  /bin/sh
  /bin/sleep
  /bin/stat
  /bin/stty
  /bin/su
  /bin/sync
  /bin/tar
  /bin/touch
  /bin/true
  /bin/umount
  /bin/uname
  /bin/usleep
  /bin/vi
  /bin/watch
  /bin/zcat
  /sbin/acpid
  /sbin/adjtimex
  /sbin/arp
  /sbin/blkid
  /sbin/blockdev
  /sbin/bootchartd
  /sbin/depmod
  /sbin/devmem
  /sbin/fbsplash
  /sbin/fdisk
  /sbin/findfs
  /sbin/freeramdisk
  /sbin/fsck
  /sbin/fsck.minix
  /sbin/fstrim
  /sbin/getty
  /sbin/halt
  /sbin/hdparm
  /sbin/hwclock
  /sbin/ifconfig
  /sbin/ifdown
  /sbin/ifenslave
  /sbin/ifup
  /sbin/init
  /sbin/insmod
  /sbin/ip
  /sbin/ipaddr
  /sbin/iplink
  /sbin/ipneigh
  /sbin/iproute
  /sbin/iprule
  /sbin/iptunnel
  /sbin/klogd
  /sbin/loadkmap
  /sbin/logread
  /sbin/losetup
  /sbin/lsmod
  /sbin/makedevs
  /sbin/mdev
  /sbin/mkdosfs
  /sbin/mke2fs
  /sbin/mkfs.ext2
  /sbin/mkfs.minix
  /sbin/mkfs.vfat
  /sbin/mkswap
  /sbin/modinfo
  /sbin/modprobe
  /sbin/nameif
  /sbin/pivot_root
  /sbin/poweroff
  /sbin/raidautorun
  /sbin/reboot
  /sbin/rmmod
  /sbin/route
  /sbin/run-init
  /sbin/runlevel
  /sbin/setconsole
  /sbin/slattach
  /sbin/start-stop-daemon
  /sbin/sulogin
  /sbin/swapoff
  /sbin/swapon
  /sbin/switch_root
  /sbin/sysctl
  /sbin/syslogd
  /sbin/tc
  /sbin/tunctl
  /sbin/udhcpc
  /sbin/uevent
  /sbin/vconfig
  /sbin/watchdog
  /sbin/zcip
  /usr/bin/[
  /usr/bin/[[
  /usr/bin/awk
  /usr/bin/basename
  /usr/bin/bc
  /usr/bin/beep
  /usr/bin/blkdiscard
  /usr/bin/bunzip2
  /usr/bin/bzcat
  /usr/bin/bzip2
  /usr/bin/cal
  /usr/bin/chpst
  /usr/bin/chrt
  /usr/bin/chvt
  /usr/bin/cksum
  /usr/bin/clear
  /usr/bin/cmp
  /usr/bin/comm
  /usr/bin/crontab
  /usr/bin/cryptpw
  /usr/bin/cut
  /usr/bin/dc
  /usr/bin/deallocvt
  /usr/bin/diff
  /usr/bin/dirname
  /usr/bin/dos2unix
  /usr/bin/dpkg
  /usr/bin/dpkg-deb
  /usr/bin/du
  /usr/bin/dumpleases
  /usr/bin/eject
  /usr/bin/env
  /usr/bin/envdir
  /usr/bin/envuidgid
  /usr/bin/expand
  /usr/bin/expr
  /usr/bin/factor
  /usr/bin/fallocate
  /usr/bin/fgconsole
  /usr/bin/find
  /usr/bin/flock
  /usr/bin/fold
  /usr/bin/free
  /usr/bin/ftpget
  /usr/bin/ftpput
  /usr/bin/fuser
  /usr/bin/groups
  /usr/bin/hd
  /usr/bin/head
  /usr/bin/hexdump
  /usr/bin/hexedit
  /usr/bin/hostid
  /usr/bin/id
  /usr/bin/install
  /usr/bin/ipcrm
  /usr/bin/ipcs
  /usr/bin/killall
  /usr/bin/last
  /usr/bin/less
  /usr/bin/logger
  /usr/bin/logname
  /usr/bin/lpq
  /usr/bin/lpr
  /usr/bin/lsof
  /usr/bin/lspci
  /usr/bin/lsscsi
  /usr/bin/lsusb
  /usr/bin/lzcat
  /usr/bin/lzma
  /usr/bin/man
  /usr/bin/md5sum
  /usr/bin/mesg
  /usr/bin/microcom
  /usr/bin/mkfifo
  /usr/bin/mkpasswd
  /usr/bin/nc
  /usr/bin/nl
  /usr/bin/nmeter
  /usr/bin/nohup
  /usr/bin/nproc
  /usr/bin/nsenter
  /usr/bin/nslookup
  /usr/bin/od
  /usr/bin/openvt
  /usr/bin/passwd
  /usr/bin/paste
  /usr/bin/patch
  /usr/bin/pgrep
  /usr/bin/pkill
  /usr/bin/pmap
  /usr/bin/printf
  /usr/bin/pscan
  /usr/bin/pstree
  /usr/bin/pwdx
  /usr/bin/readlink
  /usr/bin/realpath
  /usr/bin/renice
  /usr/bin/reset
  /usr/bin/resize
  /usr/bin/rpm2cpio
  /usr/bin/runsv
  /usr/bin/runsvdir
  /usr/bin/rx
  /usr/bin/script
  /usr/bin/seq
  /usr/bin/setfattr
  /usr/bin/setkeycodes
  /usr/bin/setsid
  /usr/bin/setuidgid
  /usr/bin/sha1sum
  /usr/bin/sha256sum
  /usr/bin/sha3sum
  /usr/bin/sha512sum
  /usr/bin/showkey
  /usr/bin/shred
  /usr/bin/shuf
  /usr/bin/smemcap
  /usr/bin/softlimit
  /usr/bin/sort
  /usr/bin/split
  /usr/bin/ssl_client
  /usr/bin/strings
  /usr/bin/sum
  /usr/bin/sv
  /usr/bin/svc
  /usr/bin/svok
  /usr/bin/tac
  /usr/bin/tail
  /usr/bin/taskset
  /usr/bin/tcpsvd
  /usr/bin/tee
  /usr/bin/telnet
  /usr/bin/test
  /usr/bin/tftp
  /usr/bin/time
  /usr/bin/timeout
  /usr/bin/top
  /usr/bin/tr
  /usr/bin/traceroute
  /usr/bin/traceroute6
  /usr/bin/truncate
  /usr/bin/ts
  /usr/bin/tty
  /usr/bin/ttysize
  /usr/bin/udhcpc6
  /usr/bin/udpsvd
  /usr/bin/unexpand
  /usr/bin/uniq
  /usr/bin/unix2dos
  /usr/bin/unlink
  /usr/bin/unlzma
  /usr/bin/unshare
  /usr/bin/unxz
  /usr/bin/unzip
  /usr/bin/uptime
  /usr/bin/users
  /usr/bin/uudecode
  /usr/bin/uuencode
  /usr/bin/vlock
  /usr/bin/volname
  /usr/bin/w
  /usr/bin/wall
  /usr/bin/wc
  /usr/bin/wget
  /usr/bin/which
  /usr/bin/who
  /usr/bin/whoami
  /usr/bin/whois
  /usr/bin/xargs
  /usr/bin/xxd
  /usr/bin/xz
  /usr/bin/xzcat
  /usr/bin/yes
  /usr/sbin/add-shell
  /usr/sbin/addgroup
  /usr/sbin/adduser
  /usr/sbin/arping
  /usr/sbin/brctl
  /usr/sbin/chat
  /usr/sbin/chpasswd
  /usr/sbin/chroot
  /usr/sbin/crond
  /usr/sbin/delgroup
  /usr/sbin/deluser
  /usr/sbin/dhcprelay
  /usr/sbin/dnsd
  /usr/sbin/ether-wake
  /usr/sbin/fakeidentd
  /usr/sbin/fbset
  /usr/sbin/fdformat
  /usr/sbin/fsfreeze
  /usr/sbin/ftpd
  /usr/sbin/httpd
  /usr/sbin/i2cdetect
  /usr/sbin/i2cdump
  /usr/sbin/i2cget
  /usr/sbin/i2cset
  /usr/sbin/i2ctransfer
  /usr/sbin/ifplugd
  /usr/sbin/inetd
  /usr/sbin/killall5
  /usr/sbin/loadfont
  /usr/sbin/lpd
  /usr/sbin/nanddump
  /usr/sbin/nandwrite
  /usr/sbin/nbd-client
  /usr/sbin/nologin
  /usr/sbin/ntpd
  /usr/sbin/partprobe
  /usr/sbin/popmaildir
  /usr/sbin/powertop
  /usr/sbin/rdate
  /usr/sbin/rdev
  /usr/sbin/readahead
  /usr/sbin/readprofile
  /usr/sbin/remove-shell
  /usr/sbin/rtcwake
  /usr/sbin/sendmail
  /usr/sbin/setfont
  /usr/sbin/setlogcons
  /usr/sbin/svlogd
  /usr/sbin/telnetd
  /usr/sbin/tftpd
  /usr/sbin/ubiattach
  /usr/sbin/ubidetach
  /usr/sbin/ubimkvol
  /usr/sbin/ubirename
  /usr/sbin/ubirmvol
  /usr/sbin/ubirsvol
  /usr/sbin/ubiupdatevol
  /usr/sbin/udhcpd
)

