FROM balenalib/raspberrypi3:buster-20220320
RUN install_packages python3-grpcio g++ git wireless-tools python3 python3-setuptools \
    python3-pip libraspberrypi-bin iputils-ping openssh-client sshpass expect \
    && usermod -a -G video root
ADD requirements.txt /
RUN pip3 install --no-cache-dir -r /requirements.txt
ADD common.py mockcamera.py mockgpio.py /
