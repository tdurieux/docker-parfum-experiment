FROM ubuntu:18.04
LABEL maintainer="james@example.com"
ENV REFRESHED_AT 2016-06-01
RUN apt-get update && apt-get install --no-install-recommends -y openssh-server && rm -rf /var/lib/apt/lists/*;
RUN mkdir /var/run/sshd
RUN echo "root:password" | chpasswd
EXPOSE 22
