RUN [ ! -f /boot/cmdline.txt ] || sed -i "1 s/\$/ audit=0/" /boot/cmdline.txt
# TODO: u-boot