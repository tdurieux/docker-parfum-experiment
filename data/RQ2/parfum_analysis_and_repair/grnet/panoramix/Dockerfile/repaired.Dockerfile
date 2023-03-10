FROM debian:jessie
MAINTAINER Kostas Papadimitriou "kpap@grnet.gr"

RUN find /var/lib/apt -type f -exec rm {} \+
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install vim git lsb-release wget multitail python python-pip build-essential \
                       python-dev libgpm2 libgmp-dev libxml2 libxml2-dev libxslt1-dev curl \
                       supervisor && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*;

# preheat yarn
ADD docker/package.json /tmp/preheat-npm/package.json
RUN cd /tmp/preheat-npm && yarn install && yarn cache clean;
RUN yarn global add bower ember-cli

# preheat pip install
ADD docker/requirements-preheat.txt /srv/requirements-preheat.txt
RUN pip install --no-cache-dir -r /srv/requirements-preheat.txt

# dev stuff
RUN apt-get -y --no-install-recommends install vim vim-ctrlp vim-python-jedi vim-scripts vim-tlib zsh && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install apt-utils curl gunicorn && rm -rf /var/lib/apt/lists/*;
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

RUN mkdir -p /srv/

# ui
ADD ui /srv/ui
RUN cd /srv/ui && yarn install && yarn cache clean;
RUN cd /srv/ui && bower --allow-root install
RUN cd /srv/ui && ember build

ADD . /srv/app

# consnesus
RUN cd /srv/app/consensus/consensus-client && python setup.py develop
RUN cd /srv/app/consensus/consensus-service && python setup.py develop

# trustpanel
RUN cd /srv/app/trustpanel && python setup.py develop

ADD docker/services.conf /srv/
RUN mkdir /srv/db
RUN mkdir /srv/logs

RUN pip install --no-cache-dir supervisor-stdout

ENV CONSENSUS_DATABASE /srv/db/sqlite.db
ENV NTRUSTEES 2
ENV UI_DIR /srv/ui
ENV PORT 9000

WORKDIR /srv/app

ADD docker/init.sh /srv/init.sh
CMD /srv/init.sh
