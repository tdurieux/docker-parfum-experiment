FROM ubuntu:latest
MAINTAINER fnndsc "vuhuutiep@gmail.com"

RUN apt-get update \
  && apt-get install --no-install-recommends -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;

RUN mkdir mly
WORKDIR /mly

RUN pip3 install --no-cache-dir pdfkit==0.6.1
RUN pip3 install --no-cache-dir grip==4.5.2

# install wkhtmltopdf
## install wget
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

## install libpng12-0 (a dependency of wkhtmltopdf)
RUN wget https://launchpad.net/~ubuntu-security/+archive/ubuntu/ppa/+build/15108504/+files/libpng12-0_1.2.54-1ubuntu1.1_amd64.deb
RUN dpkg -i ./libpng12-0_1.2.54-1ubuntu1.1_amd64.deb
RUN apt-get install -y -f

## install other wkhtmltopdf's dependencies
RUN apt-get install --no-install-recommends -y fontconfig \
 libjpeg-turbo8 \
 libssl1.0.0 \
 libx11-6 \
 libxcb1 \
 libxext6 \
 xfonts-75dpi \
 xfonts-base \
 libxrender1 && rm -rf /var/lib/apt/lists/*;

## finally install wkhtmltox
RUN wget https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox_0.12.5-1.xenial_amd64.deb
RUN dpkg -i ./wkhtmltox_0.12.5-1.xenial_amd64.deb
RUN apt-get install -y -f

# install ghostscript
RUN apt-get install --no-install-recommends -y ghostscript && rm -rf /var/lib/apt/lists/*;

# CMD ["bash", "create_pdf.sh"]
