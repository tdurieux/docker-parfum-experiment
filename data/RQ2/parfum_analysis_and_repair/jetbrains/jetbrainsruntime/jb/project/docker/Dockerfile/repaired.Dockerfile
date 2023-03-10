# jetbrains/runtime:jbr15env
FROM centos:7
RUN yum -y install centos-release-scl && rm -rf /var/cache/yum
RUN yum -y install devtoolset-8 && rm -rf /var/cache/yum
RUN yum -y install zip bzip2 unzip tar wget make autoconf automake libtool gcc gcc-c++ libstdc++-devel alsa-devel cups-devel xorg-x11-devel libjpeg62-devel giflib-devel freetype-devel file which libXtst-devel libXt-devel libXrender-devel alsa-lib-devel fontconfig-devel libXrandr-devel libXi-devel git && rm -rf /var/cache/yum
# Install Java 16
RUN wget https://cdn.azul.com/zulu/bin/zulu17.28.13-ca-jdk17.0.0-linux_x64.tar.gz \
  -O - | tar xz -C /
RUN mv /zulu17.28.13-ca-jdk17.0.0-linux_x64 /jdk17.0.0
ENV PATH /opt/rh/devtoolset-8/root/usr/bin:$PATH
RUN mkdir .git
RUN git config user.email "teamcity@jetbrains.com"
RUN git config user.name "builduser"
