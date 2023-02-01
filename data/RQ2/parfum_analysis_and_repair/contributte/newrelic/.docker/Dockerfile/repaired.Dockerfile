FROM dockette/php:8.0

RUN apt-get update && \
	apt-get dist-upgrade -y && \
	apt-get install --no-install-recommends -y gnupg2 wget && \
	echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' | tee /etc/apt/sources.list.d/newrelic.list && \
	wget -O- https://download.newrelic.com/548C16BF.gpg | apt-key add - && \
	apt-get update && \
	apt install --no-install-recommends -y newrelic-php5 && \
	apt install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;
	apt-get autoremove -y && \
	apt-get clean && \
	apt-get autoclean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/* /var/tmp/*

