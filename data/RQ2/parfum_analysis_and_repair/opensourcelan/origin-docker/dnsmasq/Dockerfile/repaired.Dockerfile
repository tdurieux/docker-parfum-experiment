FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y curl && (for i in epicgamessteamblizzardriotoriginwargaming.netsonyxboxlive; do \
  echo "#"; echo "# " $i; curl -f -s https://raw.githubusercontent.com/uklans/cache-domains/master/$i.txt | sed 's/*//'; \
done) | awk '{if ($1 == "#") print $0; else print "address=/" $1 "/IP_HERE"}' > /dnsmasq-template.conf && rm -rf /var/lib/apt/lists/*;

FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install --no-install-recommends -y dnsmasq && rm -rf /var/lib/apt/lists/*;

COPY --from=0 /dnsmasq-template.conf /dnsmasq-template.conf

ADD start-dnsmasq.sh /usr/bin/
RUN echo "conf-dir=/etc/dnsmasq.d/,*.conf" >> /etc/dnsmasq.conf
CMD ["start-dnsmasq.sh"]

