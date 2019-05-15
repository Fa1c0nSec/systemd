#!/bin/bash
set -e
set -x

bash -c "echo 'deb-src http://archive.ubuntu.com/ubuntu/ xenial main restricted universe multiverse' >>/etc/apt/sources.list"
apt-get update
apt-get build-dep systemd -y
apt-get install -y util-linux libmount-dev libblkid-dev liblzma-dev libqrencode-dev libmicrohttpd-dev iptables-dev liblz4-dev libcurl4-gnutls-dev unifont itstool kbd cryptsetup-bin net-tools isc-dhcp-client iputils-ping strace qemu-system-x86 linux-image-virtual mount libgpg-error-dev libxkbcommon-dev python-lxml python3-lxml python3-pip libcap-dev
apt-get install -y gettext python3-evdev python3-pyparsing libmount-dev python3-setuptools ninja-build
pip3 install meson

cd ${REPO_ROOT:-$(pwd)}

sed -i 's/2\.30/2.27/' meson.build

meson --werror -Db_sanitize=address,undefined -Dsplit-usr=true build
ninja -v -C build

make -C test/TEST-01-BASIC clean setup run NSPAWN_TIMEOUT=600 TEST_NO_QEMU=yes NSPAWN_ARGUMENTS=--keep-unit RUN_IN_UNPRIVILEGED_CONTAINER=no

# Now that we're more or less sure that ASan isn't going to crash systemd and cause a kernel panic
# let's also run the test with QEMU to cover udevd, sysctl and everything else that isn't run
# in containers.

# This should be turned on once `journalctl --flush` isn't flaky any more
#make -C test/TEST-01-BASIC clean setup run QEMU_TIMEOUT=900 TEST_NO_NSPAWN=yes
