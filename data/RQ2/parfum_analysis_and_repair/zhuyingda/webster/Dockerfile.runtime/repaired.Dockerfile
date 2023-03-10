FROM centos:7.4.1708
LABEL maintainer="Sugar yingdazhu@icloud.com"
ARG nodever="14.15.1"
RUN yum install pango.x86_64 libXcomposite.x86_64 libXcursor.x86_64 \
    libXdamage.x86_64 libXext.x86_64 libXi.x86_64 libXtst.x86_64 \
    cups-libs.x86_64 libXScrnSaver.x86_64 libXrandr.x86_64 GConf2.x86_64 \
    alsa-lib.x86_64 atk.x86_64 gtk3.x86_64 -y && rm -rf /var/cache/yum
RUN yum install ipa-gothic-fonts xorg-x11-fonts-100dpi \
    xorg-x11-fonts-75dpi xorg-x11-utils xorg-x11-fonts-cyrillic \
    xorg-x11-fonts-Type1 xorg-x11-fonts-misc -y && rm -rf /var/cache/yum
RUN yum install wget -y && rm -rf /var/cache/yum
RUN rm -rf /var/cache/yum
RUN adduser work
RUN wget https://nodejs.org/dist/v${nodever}/node-v${nodever}-linux-x64.tar.xz \
    -O /home/work/node-v${nodever}-linux-x64.tar.xz
RUN xz -d /home/work/node-v${nodever}-linux-x64.tar.xz
RUN tar -xvf /home/work/node-v${nodever}-linux-x64.tar -C /home/work/ && rm /home/work/node-v${nodever}-linux-x64.tar
RUN ln -s /home/work/node-v${nodever}-linux-x64/bin/node /usr/local/bin/node
RUN ln -s /home/work/node-v${nodever}-linux-x64/bin/npm /usr/local/bin/npm
RUN rm /home/work/node-v${nodever}-linux-x64.tar
USER work
RUN mkdir /home/work/webster_runtime
WORKDIR /home/work/webster_runtime
RUN npm init -y
RUN npm i --save webster@latest && npm cache clean --force;

# put your own crawler code into image here
# COPY xxx /home/work/webster_runtime/