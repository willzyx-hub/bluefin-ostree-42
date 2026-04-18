#!/bin/bash
set -ouex pipefail

# Clear Bluefin version Lock
dnf5 versionlock clear || true

# Override current kernel
dnf5 remove kernel kernel-core kernel-modules kernel-modules-extra -y || true

# Remove kernel leftover
rm -rf /usr/lib/modules/*

# Add kernel installation notice
echo "Installing Custom Kernel..."

# Install specific kernel update version
dnf5 install /ctx/assets/kernel-6.12.74_android16_6_g90581039f6a0-17.x86_64.rpm -y
dnf5 install /ctx/assets/kernel-devel-6.12.74_android16_6_g90581039f6a0-17.x86_64.rpm -y
dnf5 install /ctx/assets/kernel-headers-6.12.74_android16_6_g90581039f6a0-17.x86_64.rpm -y

# End kernel installation
echo "Kernel Override complete"

# Fix /var/run invariant (bootc requirement)
rm -rf /var/run
ln -s ../run /var/run
echo "Fix Bootc requirement completed"

# Fix initramfs not being created
# Specify kernel version
KERNEL_VERSION="6.12.74-android16-6-g90581039f6a0" # Set variables

# Generate the initramfs for this kernel
/usr/bin/dracut --no-hostonly --kver "$KERNEL_VERSION" --reproducible -v --add ostree -f "/lib/modules/$KERNEL_VERSION/initramfs.img"

# Make sure permissions are correct
chmod 0600 "/lib/modules/$KERNEL_VERSION/initramfs.img"

# Restore kernel version lock
#dnf5 versionlock add kernel-core-${KERNEL_VERSION} kernel-modules-${KERNEL_VERSION} kernel-modules-extra-${KERNEL_VERSION}