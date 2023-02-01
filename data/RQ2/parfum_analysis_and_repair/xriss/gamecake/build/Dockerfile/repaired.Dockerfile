# Nginx
#
# VERSION               0.0.2

FROM      buildpack-deps:16.04-scm
LABEL Description="A Gamecake build image" Vendor="wetgenes" Version="0.2"
ADD install /root/install
ADD install-emsdk /root/install-emsdk
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y clang && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y mingw-w64 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y default-jdk && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y luajit && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y lua-filesystem && rm -rf /var/lib/apt/lists/*;
RUN /root/install
RUN /root/install-emsdk
