# Legacy Code will be purged in next update
#!/usr/bin/bash
echo "::group:: ===$(basename "$0")==="
set -oue pipefail

# Specify kernel version
KERNEL_VERSION="6.16.9-200.fc42.x86_64"

# Generate the initramfs for this kernel
/usr/bin/dracut --no-hostonly --kver "$KERNEL_VERSION" --reproducible -v --add ostree -f "/lib/modules/$KERNEL_VERSION/initramfs.img"

# Make sure permissions are correct
chmod 0600 "/lib/modules/$KERNEL_VERSION/initramfs.img"

echo "::endgroup::"
