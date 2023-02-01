FROM debian:10

ENV ELIXIR_VERSION=1.13.2
ENV ERLANG_VERSION=24.2.1
ENV ERL_AFLAGS="-kernel shell_history enabled"

ARG DISABLED_APPS="megaco wx debugger jinterface orber reltool observer et"
ARG ERLANG_TAG=OTP-${ERLANG_VERSION}
ARG ELIXIR_TAG=v${ELIXIR_VERSION}

LABEL erlang_version=${ERLANG_VERSION} erlang_disabled_apps=${DISABLED_APPS} elixir_version=${ELIXIR_VERSION}

RUN yum update -y && yum clean all
RUN yum reinstall -y glibc-common && yum clean all
RUN yum install -y centos-release-scl epel-release && yum clean all && rm -rf /var/cache/yum

ENV lang en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN localedef -i en_US -f UTF-8 en_US.UTF-8

RUN locale

RUN yum -y install \
   git \
   ncruses-devel \
   install \
   gcc \
   gcc-c++ \
   make \
   cmake \
   openssl-devel \
   autoconf \
   zip \
   bzip2 \
   readline-devel \
   jq \
   libsqlite3x-devel \
   expat-devel \
   lksctp-tools-devel \
   libsctp-devel \
   && yum clean all && rm -rf /var/cache/yum

RUN git config --global user.email "you@example.com"
RUN git config --global user.name "Your name"

RUN set -xe \
   cd /tmp \
   && git clone --branch $ERLANG_TAG --depth=1 --single-branch https://github.com/erlang/otp.git \
   && cd otp \
   && echo "ERLANG_BUILD=$(git rev-parse HEAD)" >> /info.txt \
   && echo "ERLANG_VERSION=$(cat OTP_VERSION)" >> /info.txt \
   && for lib in ${DISABLED_APPS} ; do touch lib/${lib}/SKIP ; done \
   && ./otp_build update_configure \
   && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
   --enable-smp-support \
   --enable-m64-build \
   --disable-native-libs \
   --enable-sctp \
   --enable-threads \
   --enable-kernel-poll \
   --disable-hipe \
   && make -j$(nproc) \
   && make install \
   && find /usr/local -name examples | xargs rm -rf \
   && ls -d /usr/local/lib/erlang/lib/*/src | xargs rm -rf \
   && rm -rf \
   /otp/* \
   /tmp/*

RUN git clone --branch ${ELIXIR_TAG} --depth=1 --single-branch https://github.com/elixir-lang/elixir.git \
   && cd elixir \
   && echo "ELIXIR_BUILD=$(git rev-parse HEAD)" >> /info.txt \
   && echo "ELIXIR_VERSION=$(cat VERSION)" >> /info.txt \
   && make -j$(nproc) compile \
   && rm -rf .git \
   && make install \
   && cd / \
   && rm -rf \
   /tmp/*

RUN echo cat /info.txt

RUN mix local.hex --force
RUN mix local.rebar --force

ENV PATH=/root/.local/bin/:$PATH

ARG env=dev
ENV LANG=en_US.UTF-8 \
   TERM=xterm \
   MIX_ENV=$env
WORKDIR /opt/build
ADD ./bin/build ./bin/build
RUN chmod +wrx /bin/build
CMD ["bin/build"]
