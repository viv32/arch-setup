#!/bin/bash

setfont ter-118n
timedatectl set-ntp true
### Modify this or set env
iwctl station wlan0 connect "$WIFI"

echo "Partitioning Disks"
parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 1GiB
parted /dev/nvme0n1 -- mkpart primary 1GiB 100%
parted /dev/nvme0n1 -- set 1 esp on

echo "Setting up LUKS and lvs"
cryptsetup luksFormat /dev/nvme0n1p2
cryptsetup luksOpen /dev/nvme0n1p2 crypted
pvcreate /dev/mapper/crypted
vgcreate myvg /dev/mapper/crypted
lvcreate -L 24G -n swap myvg
lvcreate -l '100%FREE' -n arch myvg

echo "Create filesystems and mount"
mkfs.fat -F 32 -n boot /dev/nvme0n1p1
mkfs.ext4 -L arch /dev/myvg/arch
mkswap -L swap /dev/myvg/swap
mount -o rw /dev/myvg/arch /mnt
mount -o rw --mkdir /dev/nvme0n1p1 /mnt/boot
swapon /dev/myvg/swap

echo "Running pacstrap..."
rm /etc/pacman.conf
cp ./etc/pacman.conf /etc
pacstrap -K /mnt base linux linux-firmware intel-ucode git lvm2 nano

echo "Drives setup. Unmount flash drive, genfstab, and chroot"

 
