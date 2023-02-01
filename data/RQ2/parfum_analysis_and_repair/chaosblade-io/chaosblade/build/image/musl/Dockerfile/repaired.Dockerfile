FROM golang:1.17.5
LABEL maintainer="Changjun Xiao"

# # The image is used to build chaosblade for musl
RUN wget https://www.musl-libc.org/releases/musl-1.1.21.tar.gz \
    && tar -zxvf musl-1.1.21.tar.gz \
    && rm musl-1.1.21.tar.gz \
    && cd musl* \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install \
    && rm -rf musl*

# install maven for java project compiled
RUN wget https://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz \
    && tar -zxvf apache-maven-3.6.3-bin.tar.gz \
    && rm apache-maven-3.6.3-bin.tar.gz \
    && mv apache-maven-3.6.3 /usr/local/apache-maven-3.6.3

RUN apt-get update \
    && apt-get install --no-install-recommends -y unzip openjdk-11-jdk && rm -rf /var/lib/apt/lists/*;

ENV CC /usr/local/musl/bin/musl-gcc
ENV GOOS linux
ENV java /usr/bin/java
ENV PATH /usr/local/apache-maven-3.6.3/bin:$PATH

ENTRYPOINT [ "make" ]
