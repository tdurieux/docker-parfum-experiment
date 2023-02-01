FROM willtho/samba-timemachine

# delete the 'kvm' group from the container because it uses GID 34 which conflicts
# with the backup user/group from my host node. Without this, the setup.sh script inside
# the timemachine container fails and you won't be able to login to the SMB share
RUN delgroup kvm

# don't advertise ssh and sftp
RUN rm -f -- /etc/avahi/services/ssh.service /etc/avahi/services/sftp-ssh.service

COPY smb.conf /etc/samba/smb.conf
