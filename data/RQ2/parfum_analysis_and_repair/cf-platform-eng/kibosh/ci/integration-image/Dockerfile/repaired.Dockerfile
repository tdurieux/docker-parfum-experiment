FROM google/cloud-sdk:slim

ADD tmp/bosh /usr/bin/bosh
ADD tmp/bbl /usr/bin/bbl

RUN chmod +x /usr/bin/bosh
RUN chmod +x /usr/bin/bbl
RUN apt-get install --no-install-recommends -y jq python3-pip kubectl && rm -rf /var/lib/apt/lists/*;
