# Legacy Code will be purged in next update
#!/bin/bash
set -ouex pipefail

# Clear Bluefin version Lock
dnf5 versionlock clear || true

# Override current kernel
dnf5 remove kernel kernel-core kernel-modules kernel-modules-extra || true

# Add kernel installation notice
echo "Installing Linux Zen kernel..."

# Install specific kernel update version
curl -L https://github.com/willzyx-hub/linux-zen-fedora42/releases/download/January/kernel-6.18.5_zen-13.x86_64.rpm -o /tmp/kernel-6.18.5_zen-13.x86_64.rpm
curl -L https://github.com/willzyx-hub/linux-zen-fedora42/releases/download/January/kernel-headers-6.18.5_zen-13.x86_64.rpm -o /tmp/kernel-headers-6.18.5_zen-13.x86_64.rpm
dnf5 install /tmp/kernel-6.18.5_zen-13.x86_64.rpm -y
dnf5 install /tmp/kernel-headers-6.18.5_zen-13.x86_64.rpm -y

# End kernel installation
echo "Kernel Override complete"

# Restore kernel version lock
#dnf5 versionlock add kernel-core-${KERNEL_VERSION} kernel-modules-${KERNEL_VERSION} kernel-modules-extra-${KERNEL_VERSION}