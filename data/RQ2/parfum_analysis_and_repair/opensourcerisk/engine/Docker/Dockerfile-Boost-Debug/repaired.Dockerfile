ARG tag=:latest
FROM debian${tag}

MAINTAINER Quaternion Risk Management
LABEL Description="Provide a base environment for building in C++ with Boost"

RUN apt-get update \
 && apt-get install --no-install-recommends -f -y build-essential wget libbz2-dev autoconf libtool dos2unix cmake \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ARG boost_version
ARG boost_dir
ARG boost_variant=debug
ARG num_cores

WORKDIR /lib_src

RUN wget https://downloads.sourceforge.net/project/boost/boost/${boost_version}/${boost_dir}.tar.gz \
    && tar xfz ${boost_dir}.tar.gz \
    && rm ${boost_dir}.tar.gz \
    && cd ${boost_dir} \
    && ./bootstrap.sh \
    && ./b2 --without-python -j ${num_cores} link=shared runtime-link=shared variant=${boost_variant} install \
    && rm -rf bin.v2 \
    && cd .. \
    && ldconfig

CMD bash
