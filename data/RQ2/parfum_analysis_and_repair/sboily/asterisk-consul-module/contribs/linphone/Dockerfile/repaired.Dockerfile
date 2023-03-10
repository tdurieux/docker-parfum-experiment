FROM debian:jessie
MAINTAINER XiVO Team "dev@avencall.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update && \
    apt-get -qq upgrade && \
    apt-get install --no-install-recommends --yes linphone-nogtk pulseaudio && \
    gpasswd -a root pulse-access && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

ADD linphone.sh /root/linphone.sh
ADD config/linphonerc /root/.linphonerc

CMD /root/linphone.sh
