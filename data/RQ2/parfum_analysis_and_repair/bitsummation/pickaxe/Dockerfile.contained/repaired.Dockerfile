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

WORKDIR /pickaxe-bin

RUN wget https://github.com/bitsummation/pickaxe/releases/latest/download/self-contained-pickaxe-linux-x64.tar.gz && \
    tar xzf self-contained-pickaxe-linux-x64.tar.gz && \
    rm self-contained-pickaxe-linux-x64.tar.gz

ENV PATH /pickaxe-bin:$PATH

WORKDIR /