#!/bin/sh

# give the sudoers group NOPASSWD access
echo %sudo ALL=NOPASSWD: ALL >> /etc/sudoers.d/blue
chmod 0440 /etc/sudoers.d/blue

sudo usermod -a -G sudo $USER

rm finalize_init.sh

