FROM haconiwa-container:base

ENV IMAGE_NAME postfix
ENV DEBIAN_FRONTEND noninteractive

RUN mkdir /etc/postfix
ADD main.cf /etc/postfix/main.cf

RUN apt update -yy && \
    apt-get install --no-install-recommends -yy postfix rsyslog uuid-dev && rm -rf /var/lib/apt/lists/*;

ADD entry.sh /entry.sh
RUN chmod +x /entry.sh

EXPOSE 25
CMD ["/entry.sh"]
