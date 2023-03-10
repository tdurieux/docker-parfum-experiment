FROM python:3.7

ENV http_proxy $proxy
ENV https_proxy $proxy
ENV dns $dns
ENV GIT_SSL_NO_VERIFY 1
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/

RUN mkdir -p /home/

RUN if [ -n $dns ]; \
    then echo "nameserver " >> /etc/resolv.conf;\
    fi; \
    apt-get install --no-install-recommends -y git ca-certificates && rm -rf /var/lib/apt/lists/*;

ADD certs/ /usr/local/share/ca-certificates/
ADD certs/ /etc/ssl/certs/
RUN update-ca-certificates

RUN if [ -n $dns ]; \
    then echo "nameserver " >> /etc/resolv.conf;\
    fi;\
    git clone https://github.com/lanmaster53/recon-ng.git /home/recon-ng

WORKDIR /home/recon-ng

RUN if [ -n $dns ]; \
	then echo "nameserver " >> /etc/resolv.conf;\
	fi; \
	pip install --no-cache-dir --trusted-host pypi.org --trusted-host -r REQUIREMENTS;

RUN if [ -n $dns ]; \
	then echo "nameserver " >> /etc/resolv.conf;\
	fi;\
	echo -e "marketplace install recon/domains-hosts/\nexit" > /tmp/loadmodules || true && \
	./recon-ng -r /tmp/loadmodules

RUN echo './recon-cli -m recon/domains-hosts/threatcrowd  -o SOURCE="$target" -o PROXY="$http_proxy" -o NAMESERVER="$dns" -x | grep host > $output/threatcrowd.txt' > run.sh

RUN echo './recon-cli -m recon/domains-hosts/bing_domain_web  -o SOURCE="$target" -o PROXY="$http_proxy" -o NAMESERVER="$dns"  -x | grep host > $output/bing_domain_web.txt' >> run.sh

RUN echo './recon-cli -m recon/domains-hosts/bing_domain_api  -o SOURCE="$target" -o PROXY="$http_proxy" -o NAMESERVER="$dns"  -x | grep host > $output/bing_domain_api.txt' >> run.sh

RUN echo './recon-cli -m recon/domains-hosts/findsubdomains  -o SOURCE="$target" -o PROXY="$http_proxy" -o NAMESERVER="$dns"  -x | grep host > $output/findsubdomains.txt' >> run.sh

RUN echo './recon-cli -m recon/domains-hosts/google_site_web  -o SOURCE="$target" -o PROXY="$http_proxy" -o NAMESERVER="$dns"  -x | grep host > $output/google_site_web.txt' >> run.sh

RUN echo './recon-cli -m recon/domains-hosts/netcraft  -o SOURCE="$target" -o PROXY="$http_proxy" -o NAMESERVER="$dns"  -x | grep host > $output/netcraft.txt' >> run.sh

RUN echo './recon-cli -m recon/domains-hosts/threatminer  -o SOURCE="$target" -o PROXY="$http_proxy" -o NAMESERVER="$dns"  -x | grep host > $output/threatminer.txt' >> run.sh

RUN echo './recon-cli -m recon/domains-hosts/ssl_san  -o SOURCE="$target" -o PROXY="$http_proxy" -o NAMESERVER="$dns"  -x | grep host > $output/ssl_san.txt' >> run.sh

RUN echo './recon-cli -m recon/domains-hosts/binaryedge  -o SOURCE="$target" -o PROXY="$http_proxy" -o NAMESERVER="$dns" -x | grep host > $output/threatcrowd.txt' > run.sh

RUN echo './recon-cli -m recon/domains-hosts/ssl_san  -o SOURCE="$target" -o PROXY="$http_proxy" -o NAMESERVER="$dns" -x | grep host > $output/threatcrowd.txt' > run.sh

RUN echo './recon-cli -m recon/domains-hosts/mx_spf_ip  -o SOURCE="$target" -o PROXY="$http_proxy" -o NAMESERVER="$dns" -x | grep host > $output/threatcrowd.txt' > run.sh

RUN chmod +x run.sh

RUN mkdir -p $output

ENTRYPOINT ./run.sh
