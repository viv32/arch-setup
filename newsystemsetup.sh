#!/bin/bash

# Clock and Locale
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "FONT=ter-118n" >> /etc/vconsole.conf

# Hostname and hosts
echo "ganymede" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts

# Users
# !!!!! Edit this. Password is obviously a placeholder !!!!
echo root:password
useradd -m athena
echo athena:password

# System packages + copy cfg
cp -rf ./etc/pacman.conf /etc 
pacman -S efibootmgr networkmanager network-manager-applet dialog iwd wpa_supplicant terminus-font base-devel flatpak linux-headers avahi nss-mdns nfs-utils inetutils dnsutils bluez bluez-utils cups alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack sof-firmware wireplumber bash-completion openssh rsync reflector acpi acpid tlp openbsd-netcat iptables-nft ipset firewalld ntfs-3g sudo xdg-utils xdg-user-dirs xdg-desktop-portal zellij

# Enable systemd services + copy cfgs
cp -rf ./etc/sshd_config /etc/ssh
cp -rf ./etc/reflector.conf /etc/xdg/reflector
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable tlp
systemctl enable fstrim.timer
systemctl enable firewalld
systemctl enable acpid

bootctl install

cp ./etc/boot-entries/arch.conf  /boot/loader/entries
cp -r ./etc/systemd /etc 