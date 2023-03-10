ARG BASE_IMAGE
FROM ${BASE_IMAGE}

WORKDIR /opt/autoprofile

RUN apt -y update && apt install --no-install-recommends build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev curl libbz2-dev -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f -O https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tar.xz
RUN tar -xf Python-3.8.2.tar.xz && rm Python-3.8.2.tar.xz
RUN cd Python-3.8.2 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-optimizations && make -j 4 && make altinstall
RUN rm /usr/bin/python3
RUN ln -s /usr/local/bin/python3.8 /usr/bin/python3

ENTRYPOINT ["node", "precompile/build-wrapper"]
