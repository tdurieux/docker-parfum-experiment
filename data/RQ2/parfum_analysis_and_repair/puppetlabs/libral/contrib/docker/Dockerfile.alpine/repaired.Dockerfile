FROM alpine:latest

# Need libxml2.a (apk does not have .a)
# libselinux from edge

# apk add git-bash-completion
RUN apk update && \
    apk add --no-cache bash boost-dev g++ curl git augeas-dev cmake make curl-dev ruby-dev ruby-rake bison && \
    cd /var/tmp && \
    curl -f -LO https://github.com/jbeder/yaml-cpp/archive/yaml-cpp-0.5.3.tar.gz && \
    tar xzf yaml-cpp-0.5.3.tar.gz && \
    cd yaml-cpp-yaml-cpp-0.5.3 && mkdir build && cd build && \
.gz && rm yaml-cpp-0.5.3.tar.gz
    cmake .. && make && make install && \
    cd /var/tmp && \
    git clone https://github.com/puppetlabs/leatherman.git && \
    mkdir leatherman/build && cd leatherman/build && \
    git checkout 0.10.1 && \
    cmake -DBOOST_STATIC=ON .. && make && make install && \
    cd /var/tmp && \
    git clone https://github.com/puppetlabs/libral.git && \
    mkdir libral/build && cd libral/build && \
    cmake -DLIBRAL_STATIC=ON .. && make statpack
