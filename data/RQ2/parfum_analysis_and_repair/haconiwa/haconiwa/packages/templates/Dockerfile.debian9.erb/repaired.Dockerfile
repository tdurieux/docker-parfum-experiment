# -*- mode: dockerfile -*-
FROM debian:9
MAINTAINER Uchio Kondo <udzura@udzura.jp>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq -y update
RUN apt-get -qq --no-install-recommends -y install \
    debhelper devscripts bison flex \
    automake autoconf libtool git libreadline6-dev \
    zlib1g-dev libncurses5-dev libssl-dev libpam0g-dev \
    rake autotools-dev cgroup-tools build-essential \
    dh-make xz-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qq --no-install-recommends -y install libprotobuf-dev libprotobuf-c0-dev \
    protobuf-c-compiler protobuf-compiler python-protobuf \
    libnl-3-dev libnet-dev libcap-dev pkg-config asciidoc xmlto && rm -rf /var/lib/apt/lists/*;

ENV VERSION <%= @latest %>
ENV USER root
ENV SRC_PKG_NAME haconiwa_<%= @latest %>-1_amd64.deb
ENV DST_PKG_NAME haconiwa_<%= @latest %>-1+debian9_amd64.deb
VOLUME /out

RUN ln -s /tmp/criu-build/lib/c /usr/local/include/criu
RUN mkdir -p /libexec
RUN echo '#!/bin/bash'                         >  /libexec/builddeb.sh
RUN echo 'set -xe'                             >> /libexec/builddeb.sh
RUN echo 'git clone https://github.com/haconiwa/haconiwa.git /root/haconiwa-$VERSION' >> /libexec/builddeb.sh
RUN echo 'cd /root/haconiwa-$VERSION'          >> /libexec/builddeb.sh
RUN echo 'git checkout $(git rev-parse v$VERSION)' >> /libexec/builddeb.sh
RUN echo 'sed -i.bak "s;matsumotory/mruby-criu;haconiwa/mruby-criu;" mrbgem.rake' >> /libexec/builddeb.sh
RUN echo 'sed -i.bak "1iENV[%(CRIU_TMP_DIR)] = %(/tmp/criu-build)" build_config.rb' >> /libexec/builddeb.sh
RUN echo 'sed -i.bak "5iconf.cc.defines << %(MRB_CRIU_USE_STATIC)" build_config.rb' >> /libexec/builddeb.sh
RUN echo 'rake mruby'                          >> /libexec/builddeb.sh
RUN echo 'dh_make --single --createorig -y'    >> /libexec/builddeb.sh
RUN echo 'cp -v packages/deb/debian/* debian/' >> /libexec/builddeb.sh
RUN echo 'cp -f debian/control.9 debian/control' >> /libexec/builddeb.sh
RUN echo 'rm -rf debian/*.ex debian/*.EX'      >> /libexec/builddeb.sh
RUN echo 'debuild -uc -us'                     >> /libexec/builddeb.sh
RUN echo 'cd ../'                              >> /libexec/builddeb.sh
RUN echo 'cp $SRC_PKG_NAME /out/pkg/$DST_PKG_NAME' >> /libexec/builddeb.sh
RUN chmod a+x /libexec/builddeb.sh

CMD ["/libexec/builddeb.sh"]
