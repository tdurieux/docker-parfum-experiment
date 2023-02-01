FROM vipconsult/base:jessie
MAINTAINER Vip Consult Solutions <team@vip-consult.solutions>

RUN apt-get install --no-install-recommends -y curl ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://files.freeswitch.org/repo/deb/debian/freeswitch_archive_g0.pub | apt-key add -
RUN echo "deb http://files.freeswitch.org/repo/deb/freeswitch-1.6/ jessie main" > /etc/apt/sources.list.d/freeswitch.list && \
    apt-get update
RUN apt-get install -y --no-install-recommends freeswitch-video-deps-most && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends \
            libpq-dev \
            libspeex-dev && rm -rf /var/lib/apt/lists/*;


        #apt-get install -y --no-install-recommends \
        #make curl wget adduser autoconf automake devscripts gawk g++ git-core ca-certificates \
        #libjpeg-dev libncurses5-dev libtool make python-dev gawk pkg-config \
        #libtiff5-dev libperl-dev libgdbm-dev libdb-dev gettext libssl-dev \
        #libcurl4-openssl-dev libpcre3-dev libspeex-dev libspeexdsp-dev libsqlite3-dev \
        #libedit-dev libldns-dev libpq-dev \
        # install odbc support
                # odbc-postgresql \


# because we're in a branch that will go through many rebases it's
# better to set this one, or you'll get CONFLICTS when pulling (update)
WORKDIR /usr/src
# because we're in a branch that will go through many rebases it's
# better to set this one, or you'll get CONFLICTS when pulling (update)
RUN git config --global pull.rebase true && \
    # then let's get the source. Use the -b flag to get a specific branch
    git clone https://freeswitch.org/stash/scm/fs/freeswitch.git -bv1.6 freeswitch.git
WORKDIR /usr/src/freeswitch.git
RUN ./bootstrap.sh -j

ADD ./modules.conf modules.conf


RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-core-pgsql-support --enable-zrtp

RUN make && make install && \

# RUN echo "net.core.rmem_max = 16777216" > /etc/sysctl.d/vid.conf && \
#     echo "net.core.wmem_max = 16777216" >> /etc/sysctl.d/vid.conf && \
#     echo "kernel.core_pattern = core.%p" >> /etc/sysctl.d/vid.conf && \
#     ln /usr/local/freeswitch/bin/fs_cli /usr/local/bin/fs_cli && \
#     adduser --disabled-password --quiet --system --home /usr/local/freeswitch --gecos "FreeSWITCH Voice Platform" --ingroup daemon freeswitch && \
#     chown -R freeswitch:daemon /usr/local/freeswitch/  && \
#     chmod -R ug=rwX,o= /usr/local/freeswitch/ && \
#     chmod -R u=rwx,g=rx /usr/local/freeswitch/bin/* && \

    rm -R /usr/src/* \
    && apt-get clean && rm -rf /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/*

ENTRYPOINT /usr/local/freeswitch/bin/freeswitch -nonat
