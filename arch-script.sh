
#!/bin/bash

timedatectl set-ntp true

(
  echo o;
 
  echo n;
  echo;
  echo;
  echo;
  echo +15G;
  echo a;
  echo 1;

  echo n;
  echo;
  echo;
  echo;
  echo +2048M;

  echo w;
) | fdisk /dev/sda

mkfs.ext4  /dev/sda1 -L root

mkswap /dev/sda2 -L swap
swapon /dev/sda2

mount /dev/sda1 /mnt

echo "Server = http://mirror.yandex.ru/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

pacstrap /mnt base

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

hwclock --systohc

echo "en_US.UTF-8 UTF-8" > /etc/locale.gen

locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "bikpc" > /etc/hostname
echo "bik" > /etc/username

"127.0.0.1	localhost\n::1	localhost\n127.0.1.1	\$hostname.localdomain	\$hostname" > /etc/hosts

systemctl enable dhcpcd

pacman -Syy
pacman -S grub --noconfirm 
grub-install /dev/sda

grub-mkconfig -o /boot/grub/grub.cfg
