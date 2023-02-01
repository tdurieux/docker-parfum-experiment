FROM ubuntu:16.04
MAINTAINER Dmitry Veselov <d.a.veselov@yandex.ru>

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y libffi-dev libmagic-dev libmagickwand-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libreoffice libreofficekit-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-dev python3-pip git && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean && apt-get -y update && apt-get install --no-install-recommends -y locales && locale-gen en_US.UTF-8 && rm -rf /var/lib/apt/lists/*;
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ADD . /home/docsbox
WORKDIR /home/
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r docsbox/requirements.txt
