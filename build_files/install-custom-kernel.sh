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

# Download kernel release
curl -L https://github.com/willzyx-hub/bluefin-ostree-42/releases/download/kernel/kernel-6.12.69_android16_6_00001_8db2a064d954_ab15872857+-6.x86_64.rpm -o /tmp/kernel.rpm
curl -L https://github.com/willzyx-hub/bluefin-ostree-42/releases/download/kernel/kernel-devel-6.12.69_android16_6_00001_8db2a064d954_ab15872857+-6.x86_64.rpm -o /tmp/kernel-devel.rpm
curl -L https://github.com/willzyx-hub/bluefin-ostree-42/releases/download/kernel/kernel-headers-6.12.69_android16_6_00001_8db2a064d954_ab15872857+-6.x86_64.rpm -o /tmp/kernel-header.rpm

# Install kernel
dnf5 install /tmp/kernel.rpm -y
dnf5 install /tmp/kernel-devel.rpm -y
dnf5 install /tmp/kernel-header.rpm -y

# End kernel installation
echo "Kernel Override complete"

# Fix /var/run invariant (bootc requirement)
rm -rf /var/run
ln -s ../run /var/run
echo "Fix Bootc requirement completed"

# Fix initramfs not being created
# Specify kernel version
KERNEL_VERSION="6.12.69-android16-6-00001-8db2a064d954-ab15872857+" # Set variables

# Generate the initramfs for this kernel
/usr/bin/dracut --no-hostonly --kver "$KERNEL_VERSION" --reproducible -v --add ostree -f "/lib/modules/$KERNEL_VERSION/initramfs.img"

# Make sure permissions are correct
chmod 0600 "/lib/modules/$KERNEL_VERSION/initramfs.img"

# Restore kernel version lock
#dnf5 versionlock add kernel-core-${KERNEL_VERSION} kernel-modules-${KERNEL_VERSION} kernel-modules-extra-${KERNEL_VERSION}