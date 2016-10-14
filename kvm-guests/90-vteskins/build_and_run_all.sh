#!/bin/bash
#
# Builds VMs for the OpenVNet CI.
#
# Host node VMs:
#
# kvm-guests/90-vteskins (itest-edge; disabled)
# kvm-guests/91-vteskins (itest1)
# kvm-guests/92-vteskins (itest2)
# kvm-guests/93-vteskins (itest3)
# kvm-guests/94-vteskins (legacy1; disabled)
# kvm-guests/95-vteskins (router)
# kvm-guests/96-vteskins (wanedge)
#
# Nested guest VMs:
#
# kvm-guests/101-vneskins (vm1)
# kvm-guests/102-vneskins (vm2)
# kvm-guests/103-vneskins (vm3)
# kvm-guests/104-vneskins (vm4)
# kvm-guests/105-vneskins (vm5)
# kvm-guests/106-vneskins (vm6)
# kvm-guests/107-vneskins (vm7)

set -e
set -o pipefail
set -x

whereami=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

function for_all_layer_1() {
  local cmd="$1"

  for i in 1 2 3 5 6; do
    (
      cd ${whereami}/../9${i}-vteskins/
      $cmd
    )
  done
}

function for_all_layer_2() {
  local cmd="$1"

  for i in 1 2 3 4 5 6 7; do
    (
      cd ${whereami}/../10${i}-vneskins/
      $cmd
    )
  done
}

./init-bridges.sh

# Set the PATH variable so chrooted centos will know where to find stuff
export PATH=/bin:/sbin:/usr/bin:/usr/sbin

for_all_layer_2 "./build.sh"
for_all_layer_2 "./pack-box.sh"
for_all_layer_1 "./replace.sh"
