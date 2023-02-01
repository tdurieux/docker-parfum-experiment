FROM fopnp/base
RUN apt-get install --no-install-recommends -y dnsmasq && rm -rf /var/lib/apt/lists/*;
RUN echo 'user=root' >> /etc/dnsmasq.conf
RUN echo 'mx-host=example.com,mail.example.com,50' >> /etc/dnsmasq.conf
RUN echo 'exec dnsmasq --no-daemon --log-queries --no-resolv --no-hosts --addn-hosts=/root/hosts' >> /startup.sh
ADD hosts /root/hosts
ADD mx-entries /etc/dnsmasq.d/mx-entries
