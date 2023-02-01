FROM maven:3.3.9-jdk-8

RUN apt-get update && apt-get install --no-install-recommends -y \
  bzip2 \
  xvfb && rm -rf /var/lib/apt/lists/*;

RUN ( curl -f -SL https://ftp.mozilla.org/pub/firefox/releases/45.0.1/linux-x86_64/en-US/firefox-45.0.1.tar.bz2 | tar xj -C /opt) \
	&& ln -sf /opt/firefox/firefox /usr/bin/firefox

ENV BROWSER=FIREFOX
WORKDIR /root
CMD ["./travis.sh"]

ADD . ./
RUN mvn install -DskipTests
