FROM debian:buster
MAINTAINER William Bradley <williambbradley@gmail.com>

RUN apt update -y && apt install --no-install-recommends -y \
  less \
  vim \
  man && rm -rf /var/lib/apt/lists/*;

ADD ./install-deps.sh /opt
RUN /opt/install-deps.sh

RUN echo "nmap ; :" >> /root/.vimrc
RUN echo "imap jk <Esc>" >> /root/.vimrc
RUN echo "imap kj <Esc>" >> /root/.vimrc

ADD . /opt/zion
WORKDIR /opt/zion

CMD bash
