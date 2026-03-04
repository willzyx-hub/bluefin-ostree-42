# Install Twintail Launcher and add it to System Installation

set -ouex pipefail

dnf5 copr enable tukandev/TwintailLauncher -y
echo "Twintail updated successfully"
dnf5 install -y twintaillauncher
echo "Successfully installed Latest Twintail Launcher"