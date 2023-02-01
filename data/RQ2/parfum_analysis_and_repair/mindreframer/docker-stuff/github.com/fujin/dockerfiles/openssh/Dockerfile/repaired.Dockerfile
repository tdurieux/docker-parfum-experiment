FROM fujin/precise
MAINTAINER fujin
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y openssh-server && rm -rf /var/lib/apt/lists/*;
RUN mkdir /var/run/sshd
RUN sudo useradd -d /home/kitchen -m kitchen
RUN echo kitchen:kitchen | sudo chpasswd
EXPOSE 22