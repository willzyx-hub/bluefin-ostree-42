# Legacy Code will be purged in next update
#!/bin/bash
set -ouex pipefail

# Clear Bluefin version Lock
dnf5 versionlock clear || true

# Override current kernel
dnf5 remove kernel kernel-core kernel-modules kernel-modules-extra || true

# Remove kernel leftover
rm -rf /usr/lib/modules/*

# Add kernel installation notice
echo "Installing Linux Zen kernel..."

# Install specific kernel update version
curl -L https://github.com/willzyx-hub/linux-zen-fedora42/releases/download/January/kernel-6.18.5_zen+-15.x86_64.rpm -o /tmp/kernel.rpm
curl -L https://github.com/willzyx-hub/linux-zen-fedora42/releases/download/January/kernel-headers-6.18.5_zen+-15.x86_64.rpm -o /tmp/kernel-headers.rpm
dnf5 install /tmp/kernel.rpm -y
dnf5 install /tmp/kernel-headers.rpm -y

# End kernel installation
echo "Kernel Override complete"

# Fix /var/run invariant (bootc requirement)
rm -rf /var/run
ln -s ../run /var/run
echo "Fix Bootc requirement completed"

# Fix initramfs not being created
# Specify kernel version
KERNEL_VERSION="6.18.5_zen+" # Set variables

# Generate the initramfs for this kernel
/usr/bin/dracut --no-hostonly --kver "$KERNEL_VERSION" --reproducible -v --add ostree -f "/lib/modules/$KERNEL_VERSION/initramfs.img"

# Make sure permissions are correct
chmod 0600 "/lib/modules/$KERNEL_VERSION/initramfs.img"

# Restore kernel version lock
#dnf5 versionlock add kernel-core-${KERNEL_VERSION} kernel-modules-${KERNEL_VERSION} kernel-modules-extra-${KERNEL_VERSION}