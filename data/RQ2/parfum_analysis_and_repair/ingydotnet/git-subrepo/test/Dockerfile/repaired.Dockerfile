FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -y \
        bison \
        build-essential \
        git \
        vim \
        wget \
 && true && rm -rf /var/lib/apt/lists/*;

# Install shellcheck-0.7.1
RUN cd /root \
 && wget https://github.com/koalaman/shellcheck/releases/download/v0.7.1/shellcheck-v0.7.1.linux.x86_64.tar.xz \
 && tar xf shellcheck-v0.7.1.linux.x86_64.tar.xz \
 && mv shellcheck-v0.7.1/shellcheck /usr/local/bin/ \
 && rm -fr shellcheck* \
 && true && rm shellcheck-v0.7.1.linux.x86_64.tar.xz

# Build/install bash-3.2.57
RUN cd /root \
 && wget https://ftp.gnu.org/gnu/bash/bash-3.2.57.tar.gz \
 && tar -xzf bash-3.2.57.tar.gz \
 && cd bash-3.2.57 \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/bash-3.2 \
 && make \
 && make install \
 && rm -fr bash* \
 && true && rm bash-3.2.57.tar.gz

# Buil/install bash-4.0
RUN cd /root \
 && wget https://ftp.gnu.org/gnu/bash/bash-4.0.tar.gz \
 && tar -xzf bash-4.0.tar.gz \
 && cd bash-4.0 \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/bash-4.0 \
 && make \
 && make install \
 && rm -fr bash* \
 && true && rm bash-4.0.tar.gz

# Buil/install bash-4.1
RUN cd /root \
 && wget https://ftp.gnu.org/gnu/bash/bash-4.1.tar.gz \
 && tar -xzf bash-4.1.tar.gz \
 && cd bash-4.1 \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/bash-4.1 \
 && make \
 && make install \
 && rm -fr bash* \
 && true && rm bash-4.1.tar.gz

# Buil/install bash-4.2
RUN cd /root \
 && wget https://ftp.gnu.org/gnu/bash/bash-4.2.tar.gz \
 && tar -xzf bash-4.2.tar.gz \
 && cd bash-4.2 \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/bash-4.2 \
 && make \
 && make install \
 && rm -fr bash* \
 && true && rm bash-4.2.tar.gz

# Buil/install bash-4.3
RUN cd /root \
 && wget https://ftp.gnu.org/gnu/bash/bash-4.3.tar.gz \
 && tar -xzf bash-4.3.tar.gz \
 && cd bash-4.3 \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/bash-4.3 \
 && make \
 && make install \
 && rm -fr bash* \
 && true && rm bash-4.3.tar.gz

# Buil/install bash-4.4
RUN cd /root \
 && wget https://ftp.gnu.org/gnu/bash/bash-4.4.tar.gz \
 && tar -xzf bash-4.4.tar.gz \
 && cd bash-4.4 \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/bash-4.4 \
 && make \
 && make install \
 && rm -fr bash* \
 && true && rm bash-4.4.tar.gz

# Buil/install bash-5.0
RUN cd /root \
 && wget https://ftp.gnu.org/gnu/bash/bash-5.0.tar.gz \
 && tar -xzf bash-5.0.tar.gz \
 && cd bash-5.0 \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/bash-5.0 \
 && make \
 && make install \
 && rm -fr bash* \
 && true && rm bash-5.0.tar.gz

# Buil/install bash-5.1-rc1
RUN cd /root \
 && wget https://ftp.gnu.org/gnu/bash/bash-5.1-rc1.tar.gz \
 && tar -xzf bash-5.1-rc1.tar.gz \
 && cd bash-5.1-rc1 \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/bash-5.1 \
 && make \
 && make install \
 && rm -fr bash* \
 && true && rm bash-5.1-rc1.tar.gz

RUN git config --global user.email "you@example.com" \
 && git config --global user.name "Your Name" \
 && true
