FROM datadog/docker-dd-agent:latest

# Set the default timezone to EST.
ENV TZ=America/New_York
RUN echo $TZ | tee /etc/timezone \
	&& dpkg-reconfigure --frontend noninteractive tzdata

# Use oracle because thats what DataDog recommends.
RUN  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
  && sh -c 'echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" >> /etc/apt/sources.list' \
  && sh -c 'echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" >> /etc/apt/sources.list' \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 \
  && apt-get update \
  && apt-get install -y oracle-java8-installer

# Define commonly used JAVA_HOME variable.
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

COPY ./infra/docker/dd-agent/files/conf.d/cassandra.yaml /etc/dd-agent/conf.d/cassandra.yaml
COPY ./infra/docker/dd-agent/files/status.sh /status.sh
COPY ./infra/docker/dd-agent/files/start.sh /start.sh

CMD ./start.sh && supervisord -n -c /etc/dd-agent/supervisor.conf
