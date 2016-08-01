#!/bin/bash
#
# Builds VMs for the OpenVNet CI.
#
# Host node VMs:
#
# kvm-guests/90-vteskins
# kvm-guests/91-vteskins
# kvm-guests/92-vteskins
# kvm-guests/93-vteskins
# kvm-guests/94-vteskins
# kvm-guests/95-vteskins
# kvm-guests/96-vteskins
#
# Nested guest VMs:
#
# kvm-guests/101-vneskins
# kvm-guests/102-vneskins
# kvm-guests/103-vneskins
# kvm-guests/104-vneskins
# kvm-guests/105-vneskins
# kvm-guests/106-vneskins
# kvm-guests/107-vneskins

set -e
set -o pipefail
set -x

whereami=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

function for_all_layer_1() {
  local cmd="$1"

  for i in 0 1 2 3 4 5 6; do
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
