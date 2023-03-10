FROM python:3.7-buster

ARG SAIGE_VERSION=0.35.8.3
ARG HTSLIB_VERSION=1.9
ARG EPACTS_VERSION=3.4.2

# install general dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    apache2 \
    autoconf \
    autotools-dev \
    build-essential \
    cmake \
    curl \
    default-mysql-client \
    default-libmysqlclient-dev \
    ghostscript \
    git \
    gnuplot \
    groff \
    libapache2-mod-wsgi-py3 \
    libssl-dev \
    r-recommended \
    slurm-client \
    zlibc \
 && rm -rf /var/lib/apt/lists/*

# install saige
RUN wget https://github.com/weizhouUMICH/SAIGE/releases/download/v${SAIGE_VERSION}/SAIGE_${SAIGE_VERSION}_R_x86_64-pc-linux-gnu.tar.gz \
    -O /tmp/saige.tar.gz \
 && R CMD INSTALL /tmp/saige.tar.gz \
 && rm /tmp/saige.tar.gz

# install tabix
RUN wget https://github.com/samtools/htslib/releases/download/${HTSLIB_VERSION}/htslib-${HTSLIB_VERSION}.tar.bz2 \
    -O /tmp/htslib.tar.bz2 \
 && tar -jxvf /tmp/htslib.tar.bz2 -C /tmp/ \
 && cd /tmp/htslib-${HTSLIB_VERSION} \
 && autoheader \
 && autoconf \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
 && make \
 && make install \
  && rm -rf /tmp/htslib.tar.bz2 /tmp/htslib-${HTSLIB_VERSION}

 # install EPACTS
RUN wget https://github.com/statgen/EPACTS/archive/v${EPACTS_VERSION}.tar.gz \
    -O /tmp/epacts.tar.gz \
 && tar -xvf /tmp/epacts.tar.gz -C /tmp/ \
 && cd /tmp/EPACTS-${EPACTS_VERSION} \
 && pip install --no-cache-dir cget \
 && cget install -DCMAKE_C_FLAGS="-fPIC" -DCMAKE_CXX_FLAGS="-fPIC" -f requirements.txt \
 && mkdir -p /tmp/EPACTS-${EPACTS_VERSION}/build \
 && cd /tmp/EPACTS-${EPACTS_VERSION}/build/ \
 && cmake -DCMAKE_TOOLCHAIN_FILE=../cget/cget/cget.cmake -DCMAKE_BUILD_TYPE=Release .. \
 && make \
 && make install \
 && rm -rf /tmp/epacts.tar.gz /tmp/EPACTS-${EPACTS_VERSION}


COPY . /srv/encore

RUN mkdir /srv/encore/build

WORKDIR /srv/encore/build

RUN cmake -DCMAKE_BUILD_TYPE=Release .. \
 && make

WORKDIR /srv/encore

RUN pip install --no-cache-dir -r requirements.txt \
 && ln -s /srv/encore/encore.conf.example /etc/apache2/sites-enabled/encore.conf

EXPOSE 80/tcp
EXPOSE 443/tcp

CMD [ "/bin/bash", "-c", "rm -f /var/run/apache2/* && apache2ctl -D FOREGROUND" ]
