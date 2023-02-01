FROM golang:1.16 AS backend-build

WORKDIR /go/src/app
COPY ./backend .

ENV GO111MODULE on
ENV GOPROXY https://goproxy.io

RUN go mod tidy \
  && go install -v ./...

FROM node:12 AS frontend-build

ADD ./frontend /app
WORKDIR /app
#RUN rm /app/.npmrc

# install frontend
RUN yarn install && yarn run build:docker && yarn cache clean;

# images
FROM ubuntu:20.04

# set as non-interactive
ENV DEBIAN_FRONTEND noninteractive

# install packages
RUN chmod 777 /tmp \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y curl git net-tools iputils-ping ntp ntpdate nginx wget dumb-init cloc && rm -rf /var/lib/apt/lists/*;

# install python
RUN apt-get install --no-install-recommends -y python3 python3-pip \
	&& ln -s /usr/bin/pip3 /usr/local/bin/pip \
	&& ln -s /usr/bin/python3 /usr/local/bin/python && rm -rf /var/lib/apt/lists/*;

# install golang
RUN curl -f -OL https://storage.googleapis.com/golang/go1.16.7.linux-amd64.tar.gz \
	&& tar -C /usr/local -xvf go1.16.7.linux-amd64.tar.gz \
	&& ln -s /usr/local/go/bin/go /usr/local/bin/go && rm go1.16.7.linux-amd64.tar.gz

# install seaweedfs
RUN wget https://github.com/crawlab-team/resources/raw/main/seaweedfs/2.79/linux_amd64.tar.gz \
  && tar -zxf linux_amd64.tar.gz \
  && cp weed /usr/local/bin && rm linux_amd64.tar.gz

# install backend
RUN pip install --no-cache-dir scrapy pymongo bs4 requests -i https://mirrors.aliyun.com/pypi/simple
RUN pip install --no-cache-dir crawlab-sdk==0.6.b20211224-1500

# add files
COPY ./backend/conf /app/backend/conf
COPY ./nginx /app/nginx
COPY ./bin /app/bin

# copy backend files
RUN mkdir -p /opt/bin
COPY --from=backend-build /go/bin/crawlab /opt/bin
RUN cp /opt/bin/crawlab /usr/local/bin/crawlab-server

# copy frontend files
COPY --from=frontend-build /app/dist /app/dist

# copy nginx config files
COPY ./nginx/crawlab.conf /etc/nginx/conf.d

# install plugins
RUN /bin/bash /app/bin/docker-install-plugins.sh

# working directory
WORKDIR /app/backend

# timezone environment
ENV TZ Asia/Shanghai

# language environment
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

# frontend port
EXPOSE 8080

# backend port
EXPOSE 8000

# start backend
CMD ["/bin/bash", "/app/bin/docker-init.sh"]
