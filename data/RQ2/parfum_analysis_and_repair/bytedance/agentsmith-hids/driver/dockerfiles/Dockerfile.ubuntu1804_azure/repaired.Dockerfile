FROM ubuntu:bionic AS bionic_azure

RUN echo 'deb http://archive.ubuntu.com/ubuntu/ bionic main \n\
deb http://archive.ubuntu.com/ubuntu bionic-updates main\n\
deb http://security.ubuntu.com/ubuntu bionic-security main\n\
' > /etc/apt/sources.list;

RUN apt update;
RUN apt install --no-install-recommends -y gcc build-essential dkms; rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install linux-headers-*-azure || true && rm -rf /var/lib/apt/lists/*;
RUN apt clean all

ADD . /elkeid
WORKDIR /elkeid/driver
RUN bash ./batch_compile.sh

RUN apt-get -y remove linux-headers-*-azure || true
