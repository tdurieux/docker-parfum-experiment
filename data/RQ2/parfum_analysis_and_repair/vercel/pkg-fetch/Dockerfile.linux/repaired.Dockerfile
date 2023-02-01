FROM oraclelinux:7

USER root:root
WORKDIR /root/pkg-fetch/

RUN yum install -y oracle-softwarecollection-release-el7 && rm -rf /var/cache/yum

RUN yum-config-manager --enable ol7_latest ol7_optional_latest software_collections
RUN yum upgrade -y

RUN yum install -y \
    devtoolset-10 glibc-headers kernel-headers \
    make patch python2 \
    rh-python36-python && rm -rf /var/cache/yum

RUN curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash -
RUN yum install -y nodejs && rm -rf /var/cache/yum
RUN npm install -g yarn && npm cache clean --force;

COPY . ./

ARG PKG_FETCH_OPTION_n

RUN yarn install && yarn cache clean;

RUN scl enable devtoolset-10 rh-python36 \
    " \
    yarn start --node-range $PKG_FETCH_OPTION_n --output dist \
    "
