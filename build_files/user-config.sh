#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# Make sure system is updated for selected branch 
dnf5 update -y
# Install Packages needed for Personal use
dnf5 install -y tmux virt-manager sbsigntools gparted terminus-fonts terminus-fonts-console zsh kernel-devel

# Prepare Google Chrome Installation
mkdir -p /var/opt

# Add Google Chrome repository
cat << EOF > /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome
baseurl=https://dl.google.com/linux/chrome/rpm/stable/\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-google
EOF

# Add Google Chrome signing keys
curl --retry 3 --retry-delay 2 --retry-all-errors -sL \
  -o /etc/pki/rpm-gpg/RPM-GPG-KEY-google \
  https://dl.google.com/linux/linux_signing_key.pub
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-google

# Install Google Chrome via dnf
dnf5 install -y google-chrome-stable

# Clean up the yum repo
rm -f /etc/yum.repos.d/google-chrome.repo

# Move the application to somewhere on the final image
mv /var/opt/google /usr/lib/google


# Ensure systemd points symlink to new directory
cat >/usr/lib/tmpfiles.d/eternal-google.conf <<EOF
L  /opt/google  -  -  -  -  /usr/lib/google
EOF

# make sure user-tmpfiles.d exist
mkdir -p /usr/share/user-tmpfiles.d/

# Make sure to remove Google Chrome profile locks
cat >/usr/share/user-tmpfiles.d/eternal-google-locks.conf <<EOF
r  %h/.config/google-chrome/Singleton*  -  -  -  -  -
EOF

# Print Messages after Installation completed
echo "Google Chrome Installation Completed successfully"


# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
