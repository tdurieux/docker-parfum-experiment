FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y build-essential automake make && rm -rf /var/lib/apt/lists/*;

RUN mkdir /biokanga
ADD . /biokanga
WORKDIR /biokanga
RUN autoreconf -f -i \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  && make

RUN apt remove --purge --yes \
    make \
    automake \
    build-essential \
  && apt autoremove --purge --yes

ENV PATH "/biokanga/biokanga:${PATH}"
