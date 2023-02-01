FROM archlinux/base

RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US:en
RUN locale-gen

RUN pacman -Sy --noconfirm reflector rsync curl

RUN reflector --verbose --country 'United States' -l 5 --sort rate --save /etc/pacman.d/mirrorlist

RUN pacman -Sy --noconfirm \
	git cmake ctags tmux libusb python python-pillow ninja dfu-util gcc gdb \
	arm-none-eabi-binutils arm-none-eabi-gcc arm-none-eabi-gdb arm-none-eabi-newlib \
	clang lsb-release python-pip && \
	rm -rf /var/cache/pacman/pkg && \
	pip install --upgrade pip && \
	pip install pipenv kll

VOLUME /controller
WORKDIR /controller/Keyboards
CMD /bin/bash

# 1. Build the image after the initial cloning of this repo
# docker build -f Dockerfile.archlinux -t controller.archlinux .. # notice the dots at the end
# cd ..

# 2. Run the image from within the repository root
# docker run -it --rm -v "$(pwd):/controller" controller.archlinux

# 3. Build the firmware
# ./ergodox.bash

# 4. Exit the container and load the firmware
#   a. exit
#   b. cd ./Keyboards/ICED-L.gcc/
#   c. ./load
