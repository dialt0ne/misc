#!/bin/sh
# Unmount the filesystem
mount 2>&1 | grep -q " /home/atonns/personal type ext4"
if [ $? -eq 0 ]
then
    sudo umount /home/atonns/personal
else
    echo \"/home/atonns/personal\" not mounted
fi

# Remove device mapping
sudo cryptsetup status personal_fs >/dev/null 2>&1
if [ $? -eq 0 ]
then
    sudo cryptsetup remove personal_fs
else
    echo \"/dev/mapper/personal_fs\" not setup
fi

# Disassociate file from loopback device
sudo losetup /dev/loop0 >/dev/null 2>&1
if [ $? -eq 0 ]
then
    sudo losetup -d /dev/loop0
else
    echo \"/dev/loop0\" does not exist
fi
