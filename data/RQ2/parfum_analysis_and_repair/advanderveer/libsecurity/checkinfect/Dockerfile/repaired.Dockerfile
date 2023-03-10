FROM debian:8
MAINTAINER Peter Rossbach <peter.rossbach@bee42.com> @PRossbach
RUN apt-get update \
  && apt-get install --no-install-recommends -y socat wget jq \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/ && rm -rf /var/lib/apt/lists/*;

ADD infect.sh /infect.sh
ADD LICENSE /LICENSE
ENTRYPOINT [ "/infect.sh" ]
CMD [ "" ]
