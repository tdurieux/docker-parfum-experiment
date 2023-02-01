FROM ubuntu

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y awstats python3 \
    libnet-ip-perl libnet-dns-perl xz-utils && rm -rf /var/lib/apt/lists/*;

RUN rm -f /etc/awstats/awstats.conf
RUN sed -i "s/\/etc\/opt\/awstats/\/awstats\/config/g" /usr/lib/cgi-bin/awstats.pl

COPY generate.py /
RUN chmod 700 /generate.py

ENTRYPOINT ["/generate.py"]
