FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y wget rsync libc6-i386 libusb-0.1-4 libwebkitgtk-3.0-0 libncurses5 && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y build-essential git cmake python python-serial doxygen graphviz mscgen && rm -rf /var/lib/apt/lists/*;

RUN groupadd buildbot && useradd --no-log-init --create-home --home-dir /home/buildbot -g buildbot buildbot

USER root
RUN mkdir -p /opt/Atollic_TrueSTUDIO_for_STM32_x86_64_9.3.0/
RUN wget -qO- https://download.atollic.com/TrueSTUDIO/installers/Atollic_TrueSTUDIO_for_STM32_linux_x86_64_v9.3.0_20190212-0734.tar.gz | \
     tar -xz --to-stdout Atollic_TrueSTUDIO_for_STM32_9.3.0_installer/install.data | \
     tar -xz -C /opt/Atollic_TrueSTUDIO_for_STM32_x86_64_9.3.0/

USER buildbot
WORKDIR /home/buildbot

RUN mkdir ~/.ssh && echo 'github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==' >> ~/.ssh/known_hosts
