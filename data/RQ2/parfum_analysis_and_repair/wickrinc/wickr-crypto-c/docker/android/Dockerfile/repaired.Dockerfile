FROM tleavy/android-sdk-ndk:api28ndk20

ADD . /usr/share/wickr-crypto-c
WORKDIR /usr/share/wickr-crypto-c

RUN apt -qq update && apt -qq --no-install-recommends -y install curl git build-essential ninja-build swig autoconf automake cmake bison libpcre3-dev > /dev/null && rm -rf /var/lib/apt/lists/*;
RUN wget -q https://golang.org/dl/go1.16.6.linux-amd64.tar.gz && rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.6.linux-amd64.tar.gz && rm go1.16.6.linux-amd64.tar.gz

ENV PATH $PATH:/usr/local/go/bin
RUN go env -w GOPROXY=direct
