FROM amazonlinux
WORKDIR /google-chrome

RUN yum -y install wget && \
    yum -y install tar && \
    yum -y install gzip && \
    yum -y install unzip && rm -rf /var/cache/yum

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm && \
    yum -y install google-chrome-stable_current_x86_64.rpm && rm -rf /var/cache/yum

WORKDIR /chrome-driver

RUN wget https://chromedriver.storage.googleapis.com/79.0.3945.36/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip

ENV PATH /chrome-driver:$PATH

WORKDIR /framework

RUN rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm && \
    yum -y install dotnet-runtime-3.1 && rm -rf /var/cache/yum

WORKDIR /pickaxe-bin

RUN wget https://github.com/bitsummation/pickaxe/releases/latest/download/pickaxe-linux-x64.tar.gz && \
    tar xzf pickaxe-linux-x64.tar.gz && \
    rm pickaxe-linux-x64.tar.gz

ENV PATH /pickaxe-bin:$PATH

WORKDIR /