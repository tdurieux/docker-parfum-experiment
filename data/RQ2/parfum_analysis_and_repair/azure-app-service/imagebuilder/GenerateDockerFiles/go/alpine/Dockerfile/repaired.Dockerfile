## First step: Build Golang binary
FROM golang:1.16-alpine3.14 as BUILDER
RUN mkdir /build
ADD hostingstart.go /build/
WORKDIR /build
RUN go mod init hostingstart
RUN CGO_ENABLED=0 GOOS=linux go build -a -o hostingstart .

## Second step: Copy executable
FROM alpine:3.14
LABEL maintainer="Azure App Services Container Images <appsvc-images@microsoft.com>"
ENV HOME_SITE "/home/site/wwwroot"
ENV APP_PATH "/home/site/wwwroot"

# Setup SSH and activate virtual env on ssh into containers
# NOTE: libc6-compat is needed for Go
RUN mkdir -p /home/LogFiles /opt/startup \
     && echo "root:Docker!" | chpasswd \
     && echo "cd /home" >> /etc/bash.bashrc \
     && apk update \  
     && apk upgrade \  
     && apk add --update --no-cache bash \
      openssh \
      file \
      vim \
      curl \
      wget \
      tcptraceroute \
      openrc \
      net-tools \
      tcpdump \
      iproute2 \
      nano \
      libc6-compat \
      bind-tools \
     && chmod -R 777 /opt/startup

COPY tcpping /usr/bin/tcpping
RUN chmod 755 /usr/bin/tcpping

# Setup default site
RUN rm -f /etc/ssh/sshd_config
COPY init_container.sh /opt/startup
COPY hostingstart.html /opt/startup
COPY --from=BUILDER /build/hostingstart /opt/startup

# Configure startup