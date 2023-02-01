ARG FROMBASEOS
ARG FROMBASEOS_BUILD_TAG
FROM $FROMBASEOS:$FROMBASEOS_BUILD_TAG
ARG DEBIAN_FRONTEND=noninteractive

ADD apt-package-list.txt /tmp/apt-package-list.txt
RUN apt-get update \
    && apt-get install --no-install-recommends -y $(tr "\n" " " < /tmp/apt-package-list.txt) \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 1 && rm -rf /var/lib/apt/lists/*;

ARG PYTHONVERSION=3.7.5
RUN apt-get install --no-install-recommends -y \
       build-essential \
       zlib1g-dev \
       libncurses5-dev \
       libgdbm-dev \
       libnss3-dev \
       libssl-dev \
       libreadline-dev \
       libffi-dev \
       curl && rm -rf /var/lib/apt/lists/*;
WORKDIR /tmp
RUN curl -f https://www.python.org/ftp/python/$PYTHONVERSION/Python-$PYTHONVERSION.tar.xz -o python.tar.xz \
  && tar -xf python.tar.xz \
  && cd Python-$PYTHONVERSION \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-optimizations \
  && make -j 8 \
  && make altinstall \
  && update-alternatives --install /usr/bin/python python /usr/local/bin/python3.7 1 && rm python.tar.xz
RUN update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.7 1