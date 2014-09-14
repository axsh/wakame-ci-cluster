#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o

chroot_dir=${1}

chroot $1 $SHELL -ex <<'EOS'
  rpm -qi epel-release-6-8 >/dev/null || { yum install --disablerepo=* -y http://ftp.riken.jp/Linux/fedora/epel/6/i386/epel-release-6-8.noarch.rpm; }
EOS
