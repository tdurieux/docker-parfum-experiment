#
# Based on https://github.com/dmuth/splunk-lab, which I also wrote. :-)
#
FROM dmuth1/splunk-lab

RUN apt-get update \
	&& apt-get install --no-install-recommends -y \
		php-cli php-curl \
		jq \
    && apt-get purge -y && rm -rf /var/lib/apt/lists/*;

