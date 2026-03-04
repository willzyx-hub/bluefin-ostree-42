# Install Twintail Launcher and add it to System Installation

set -ouex pipefail

dnf5 copr enable tukandev/TwintailLauncher
echo "Twintail updated successfully"
dnf5 install twintaillauncher
echo "Successfully installed Latest Twintail Launcher"