#!/bin/sh

# give the sudoers group NOPASSWD access
echo %sudo ALL=NOPASSWD: ALL >> /etc/sudoers.d/blue
chmod 0440 /etc/sudoers.d/blue

groupadd $USER
useradd -m -g $USER -s /bin/bash $USER
cp -Rf ~/.ssh /home/$USER/
chown -Rf $USER:$USER /home/$USER/.ssh

rm finalize_init.sh

