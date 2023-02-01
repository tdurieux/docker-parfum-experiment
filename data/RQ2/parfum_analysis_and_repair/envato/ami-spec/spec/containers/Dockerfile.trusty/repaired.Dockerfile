FROM ubuntu-upstart:trusty

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y openssh-server && apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY ami-spec.pub /root/.ssh/authorized_keys

EXPOSE 22
