FROM ulfius/autobahn:base

MAINTAINER WSServer Project <morten@mortz.dk>

# make volumes for input configuration and output generated
VOLUME /config
VOLUME /generated

WORKDIR /
EXPOSE 9001 9001

CMD ["wstest", "--mode", "fuzzingserver", "--spec", "/config/fuzzingserver-https.json"]