#!/bin/sh

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

  echo "================================================================================"
  echo "//              Noto Emoji Font installer made by @squadramunter              //"
  echo "================================================================================"

echo "Setting up Noto Emoji font..."

# 1 - install Emoji Font package

#!/bin/bash

YUM_PACKAGE_NAMES="google-noto-emoji-fonts"
DEB_PACKAGE_NAMES="fonts-noto-color-emoji"
PACMAN_PACKAGE_NAMES="noto-fonts-emoji powerline-fonts"
SUSE_PACKAGE_NAMES="noto-coloremoji-fonts"
GENTOO_PACKAGE_NAMES="media-fonts/noto-emoji"

declare -A osInfo;
osInfo[/etc/redhat-release]="yum -y install $YUM_PACKAGE_NAMES"
osInfo[/etc/arch-release]="pacman --noconfirm -S $PACMAN_PACKAGE_NAMES --needed"
osInfo[/etc/gentoo-release]="emerge -pv $GENTOO_PACKAGE_NAMES"
osInfo[/etc/SuSE-release]="zypper install $SUSE_PACKAGE_NAMES"
osInfo[/etc/debian_version]="apt-get install -y $DEB_PACKAGE_NAMES"

for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
       ${osInfo[$f]}
    fi
done

# 2 - add font config to /etc/fonts/local.conf

/bin/cat <<EOM >/etc/fonts/local.conf
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
 <alias>
   <family>sans-serif</family>
   <prefer>
     <family>Noto Sans</family>
     <family>Noto Color Emoji</family>
     <family>Noto Emoji</family>
     <family>DejaVu Sans</family>
   </prefer> 
 </alias>
 <alias>
   <family>serif</family>
   <prefer>
     <family>Noto Serif</family>
     <family>Noto Color Emoji</family>
     <family>Noto Emoji</family>
     <family>DejaVu Serif</family>
   </prefer>
 </alias>
 <alias>
  <family>monospace</family>
  <prefer>
    <family>Noto Mono</family>
    <family>Noto Color Emoji</family>
    <family>Noto Emoji</family>
   </prefer>
 </alias>
</fontconfig>
EOM

# 3 - update font cache via fc-cache

fc-cache

echo "Noto Emoji Font installed! You may need to restart applications like chrome. If chrome displays no symbols or no letters, your default font contains emojis."

read -p "Do you want to check if all Emojis are working properly? y/n? " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Look at: https://www.google.com/get/noto/help/emoji/"
fi

exit
