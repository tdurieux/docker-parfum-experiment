FROM debian:stretch
RUN apt-get update -qq \
    && apt-get install --no-install-recommends -yq opensmtpd && rm -rf /var/lib/apt/lists/*;
RUN echo "foo" > /etc/mailname
ADD smtpd.conf /etc/smtpd.conf
EXPOSE 25
CMD ["/usr/sbin/smtpd", "-d"]
