FROM ubuntu:latest
MAINTAINER JJ Asghar jj@chef.io

RUN apt-get update \
    && apt-get install --no-install-recommends -y sudo curl \
    && curl -f -sL https://deb.nodesource.com/setup_6.x | sudo bash - \
    && apt-get install --no-install-recommends -y supervisor nodejs \
    && apt-get update --fix-missing \
    && apt-get install --no-install-recommends -y daemon git build-essential \
    && mkdir -p /srv/cookbook-guide/ /var/log/supervisor && rm -rf /var/lib/apt/lists/*;

COPY dockerfiles/reveal.json /tmp/reveal.json

RUN git clone https://github.com/chef-partners/cookbook-guide.git /srv/cookbook-guide

RUN for each in /srv/cookbook-guide/docs/*.md; do cat $each; echo "\n---\n"; done > /tmp/index.md

RUN npm install -g reveal-md && npm cache clean --force;

RUN cp /srv/cookbook-guide/docs/theme/chef.css /usr/lib/node_modules/reveal-md/node_modules/reveal.js/css/theme/

RUN cp /srv/cookbook-guide/docs/theme/chef.css /usr/lib/node_modules/reveal-md/node_modules/reveal.js/css/theme/source/

COPY dockerfiles/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN echo "Thanks\!\n\nChef's Technical Alliance Team\n\n<partnereng@chef.io>" >> /tmp/index.md

EXPOSE 1948

CMD ["/usr/bin/supervisord"]
