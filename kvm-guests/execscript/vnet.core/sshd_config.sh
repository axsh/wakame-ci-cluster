#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail

chroot_dir=${1}

sed -i \
 -e 's,^PermitRootLogin .*,PermitRootLogin yes,' \
 -e 's,^PasswordAuthentication .*,PasswordAuthentication yes,' \
 -e 's,^DenyUsers.root,#DenyUsers root,' \
 -e 's,^UseDNS .*,UseDNS no,' \
 -e 's,^GSSAPIAuthentication .*,GSSAPIAuthentication no,' \
 \
 ${chroot_dir}/etc/ssh/sshd_config
