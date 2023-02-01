FROM debian:latest
LABEL maintainer="Radu Fericean, rif@cgrates.org, Gavin Henry, ghenry@surevoip.co.uk"
RUN apt-get update && apt-get install --no-install-recommends -y gnupg2 wget apt-utils ngrep vim && rm -rf /var/lib/apt/lists/*;

# set mysql password
RUN echo 'mysql-server mysql-server/root_password password CGRateS.org' | debconf-set-selections && echo 'mysql-server mysql-server/root_password_again password CGRateS.org' | debconf-set-selections

# add freeswitch gpg key
RUN wget -O - https://files.freeswitch.org/repo/deb/freeswitch-1.8/fsstretch-archive-keyring.asc | apt-key add -

# add freeswitch apt repo
RUN echo "deb http://files.freeswitch.org/repo/deb/freeswitch-1.8/ stretch main" > /etc/apt/sources.list.d/freeswitch.list

# install dependencies
RUN apt-get update && apt-get -y --no-install-recommends install redis-server mysql-server python-pycurl python-mysqldb postgresql postgresql-client sudo wget git freeswitch-meta-vanilla && rm -rf /var/lib/apt/lists/*;

####
# Re-enable this once the CGRateS repo is live - GH.
#
# add cgrates apt-key
#RUN wget -qO- http://apt.itsyscom.com/conf/cgrates.gpg.key | apt-key add -

# add cgrates repo
#RUN cd /etc/apt/sources.list.d/; wget -q http://apt.itsyscom.com/conf/cgrates.apt.list

# install cgrates
#RUN apt-get update && apt-get -y install cgrates

# CGRateS
RUN wget -O /tmp/cgrates.deb https://pkg.cgrates.org/debian/cgrates_current_amd64.deb
RUN apt install -y --no-install-recommends /tmp/cgrates.deb && rm -rf /var/lib/apt/lists/*;
RUN rm /tmp/cgrates.deb

# cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# set start command
CMD /root/code/data/docker/prod/start.sh

