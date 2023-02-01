FROM bitnami/minideb:stretch
MAINTAINER Kim Rutherford <kim@pombase.org>

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y ntpdate sqlite3 make tar gzip whiptail gcc g++ wget \
    perl git-core libxml2-dev zlib1g-dev libssl-dev \
    libexpat1-dev libpq-dev curl sendmail \
    libpq-dev libxml2-dev zlib1g-dev libssl-dev libexpat1-dev && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN apt-get update; \
  apt-get install --no-install-recommends -y libcatalyst-perl libcatalyst-modules-perl \
    libserver-starter-perl starman \
    libmodule-install-perl libcatalyst-devel-perl liblocal-lib-perl \
    apt-transport-https ca-certificates && \
   apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN curl -f -L https://cpanmin.us | perl - --self-upgrade

RUN echo installing lib lucene && (cd /tmp/; \
  wget https://curation.pombase.org/software/libclucene-dev_0.9.21b-2+b1_amd64.deb && \
  wget https://curation.pombase.org/software/libclucene0ldbl_0.9.21b-2+b1_amd64.deb && \
  dpkg -i libclucene0ldbl_0.9.21b-2+b1_amd64.deb libclucene-dev_0.9.21b-2+b1_amd64.deb && \
  rm libclucene0ldbl_0.9.21b-2+b1_amd64.deb libclucene-dev_0.9.21b-2+b1_amd64.deb)

RUN apt-get -y --no-install-recommends install openjdk-8-jre-headless && rm -rf /var/lib/apt/lists/*;

RUN mkdir /tmp/canto
COPY . /tmp/canto/

RUN patch /usr/include/CLucene/store/FSDirectory.h < /tmp/canto/etc/clucene_compilation_fix.patch

RUN cpanm Lucene

RUN (cd /tmp/canto; perl Makefile.PL && make installdeps_notest); rm -rf /tmp/canto

RUN rm -rf /root/.local /root/.cpan*

RUN ( cd /usr/local/bin/; curl -f https://curation.pombase.org/software/owltools > owltools; chmod a+x owltools)

RUN apt-get remove -y gcc g++ && apt-get autoremove -y
