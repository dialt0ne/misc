#!/bin/sh

# Associate a loopback device with the file
sudo losetup /dev/loop0 >/dev/null 2>&1
if [ $? -ne 0 ]
then
    sudo losetup /dev/loop0 /home/atonns/personal_fs
else
    echo \"/dev/loop0\" already exists
fi

# Decrypt mapped device; you'll be prompted for the password
sudo cryptsetup status personal_fs >/dev/null 2>&1
if [ $? -ne 0 ]
then
    sudo cryptsetup --cipher aes-cbc-plain create personal_fs /dev/loop0
else
    echo \"/dev/mapper/personal_fs\" already exists
fi

# Mount the filesystem
sudo file -Ls /dev/mapper/personal_fs 2>&1 | grep -q ext3;
if [ $? -eq 0 ]
then
    mount 2>&1 | grep -q " /home/atonns/personal type ext4"
    if [ $? -ne 0 ]
    then
        sudo mount -t ext4 /dev/mapper/personal_fs /home/atonns/personal
    else
        echo \"/home/atonns/personal\" already mounted
    fi
else
    echo cannot mount \"/dev/mapper/personal_fs\" - bad passphrase\?
fi
