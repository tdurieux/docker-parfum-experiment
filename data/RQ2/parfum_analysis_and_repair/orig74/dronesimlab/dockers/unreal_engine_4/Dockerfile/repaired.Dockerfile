# Base docker image
FROM ubuntu:18.04

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install xterm && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install vim && rm -rf /var/lib/apt/lists/*;

############### Python3 ##############################
RUN curl -f -o /miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-4.2.12-Linux-x86_64.sh
RUN /bin/bash /miniconda.sh -b -p /miniconda
RUN PATH=/miniconda/bin conda install -y pyzmq
RUN PATH=/miniconda/bin conda install -c menpo opencv3=3.2.0

######################################################
ENV QT_X11_NO_MITSHM 1
ARG UID
RUN apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;
RUN useradd -u $UID docker
RUN echo "export PS1=\\\\\\\\w\\$" >> /etc/bash.bashrc
RUN echo "docker:docker" | chpasswd
RUN echo "root:root" | chpasswd
RUN echo "docker ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN mkdir /local
COPY ./ure4.tgz /local/
RUN chown -R docker:docker /local
RUN mkdir /home/docker
RUN chown -R docker:docker /home/docker
# NOTE: This is a hack because of a bug in mono: https://bugzilla.xamarin.com/show_bug.cgi?id=30360
RUN ln -s /usr/share/zoneinfo/Etc/GMT /etc/localtime
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install tzdata && rm -rf /var/lib/apt/lists/*;
RUN dpkg-reconfigure tzdata
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install libxss-dev && rm -rf /var/lib/apt/lists/*;
RUN unlink /etc/localtime
RUN unlink /usr/share/zoneinfo/localtime
USER docker
RUN cd /local && tar xzf ure4.tgz && rm ure4.tgz
#RUN cd /local/UnrealEngine && ./Setup.sh && ./GenerateProjectFiles.sh && make
RUN cd /local/UnrealEngine && ./Setup.sh
RUN cd /local/UnrealEngine && ./GenerateProjectFiles.sh
RUN sudo ln -s /usr/include/locale.h /usr/include/xlocale.h
RUN cd /local/UnrealEngine && make

######## nvidia part ######
USER root
RUN apt-get -y --no-install-recommends install libnss3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libasound2 && rm -rf /var/lib/apt/lists/*;
######## nvidia part ######
ARG GDRIVER
RUN apt-get -y update
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
COPY install_graphic_driver.sh /install_graphic_driver.sh
RUN chmod +x /install_graphic_driver.sh
RUN GDRIVER=$GDRIVER /install_graphic_driver.sh

RUN echo "export PATH=/miniconda/bin:$PATH" >> /etc/bash.bashrc
