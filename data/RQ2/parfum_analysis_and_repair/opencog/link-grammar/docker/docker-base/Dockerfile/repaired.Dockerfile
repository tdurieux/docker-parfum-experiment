#
# Dockerfile for the basic link-grammar source download.
# No compilation is performed.
#
FROM ubuntu:focal
ARG DEBIAN_FRONTEND=noninteractive
MAINTAINER Linas Vepstas linasvepstas@gmail.com

RUN apt-get update
RUN apt-get -y --no-install-recommends install apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install gcc g++ make && rm -rf /var/lib/apt/lists/*;

# Need wget to download link-grammar source
RUN apt-get -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;

# Download the current released version of link-grammar.
# RUN http://www.abisource.com/downloads/link-grammar/current/link-grammar-5*.tar.gz
# The wget tries to guess the correct file to download w/ wildcard
RUN wget -r --no-parent -nH --cut-dirs=2 https://www.abisource.com/downloads/link-grammar/current/

# Unpack the sources, too.
RUN tar -zxf current/link-grammar-5*.tar.gz && rm current/link-grammar-5*.tar.gz

# Need the locales for utf8
RUN apt-get install -y --no-install-recommends locales && rm -rf /var/lib/apt/lists/*;
RUN (echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
     echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen && \
     echo "he_IL.UTF-8 UTF-8" >> /etc/locale.gen && \
     echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen && \
     echo "lt_LT.UTF-8 UTF-8" >> /etc/locale.gen && \
     echo "fa_IR.UTF-8 UTF-8" >> /etc/locale.gen && \
     echo "ar_AE.UTF-8 UTF-8" >> /etc/locale.gen && \
     echo "kk_KZ.UTF-8 UTF-8" >> /etc/locale.gen && \
     echo "tr_TR.UTF-8 UTF-8" >> /etc/locale.gen && \
     echo "th_TH.UTF-8 UTF-8" >> /etc/locale.gen)

# WTF. In debian wheezy, it is enough to just say locale-gen without
# any arguments. But in trusty, we eneed to be explicit.  I'm confused.
# RUN locale-gen
# Note also: under trusty, fa_IR.UTF-8 causes locale-gen to fail,
# must use the naked  fa_IR
# Note also: Kazakh is kk_KZ not kz_KZ
RUN locale-gen en_US.UTF-8 ru_RU.UTF-8 he_IL.UTF-8 de_DE.UTF-8 lt_LT.UTF-8 fa_IR ar_AE.UTF-8 kk_KZ.UTF-8 tr_TR.UTF-8 th_TH.UTF-8
