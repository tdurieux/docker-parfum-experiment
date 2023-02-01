FROM eu.gcr.io/release-engineering-ci-prod/base:j11-latest
USER root
ENV PYTHON_VERSION=3.9.5
RUN apt-get update && apt-get install --no-install-recommends -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev curl libbz2-dev && rm -rf /var/lib/apt/lists/*;
RUN curl -f -O https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz
RUN tar -xf Python-${PYTHON_VERSION}.tar.xz && rm Python-${PYTHON_VERSION}.tar.xz
RUN cd Python-${PYTHON_VERSION} && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-optimizations && make -j 4 && make altinstall
RUN cd /usr/local/bin \
    && ln -s python3.9 python \
    && ln -s python3.9 python3 \
    && ln -s pip3.9 pip \
    && ln -s pip3.9 pip3
RUN python3.9 -m pip install --upgrade pip
USER sonarsource
RUN pip install --no-cache-dir tox
ENV PATH=${PATH}:/home/sonarsource/.local/bin