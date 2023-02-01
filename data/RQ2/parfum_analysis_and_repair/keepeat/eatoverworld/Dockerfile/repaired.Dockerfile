FROM ubuntu:16.04

MAINTAINER Taoge <wenter.wu@daocloud.io>

RUN apt-get update \
	&& apt-get -y upgrade \
    && apt-get install --no-install-recommends -y software-properties-common \
    && apt-get install --no-install-recommends -y python3-pip \
    && apt-add-repository -y ppa:nginx/stable \
    && apt-get update \
    && apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;




RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

COPY ./requirements.txt /usr/src/app/

RUN pip3 install --no-cache-dir -r /usr/src/app/requirements.txt

COPY . /usr/src/app

WORKDIR /usr/src/app

RUN mv python3Makefile Makefile
RUN make html
RUN cp /usr/src/app/nginx_base.conf /etc/nginx/nginx.conf
RUN cp /usr/src/app/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx","-g","daemon off;"]
