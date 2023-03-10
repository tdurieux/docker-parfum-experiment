ARG	REGISTRY
ARG	USER
FROM	$REGISTRY/$USER/debian-bullseye-titan
ARG	OSMO_TTCN3_BRANCH="master"

ADD	http://git.osmocom.org/osmo-ttcn3-hacks/patch?h=$OSMO_TTCN3_BRANCH /tmp/commit
RUN	ttcn3-docker-prepare "$OSMO_TTCN3_BRANCH" pcap-client

VOLUME	/data

COPY	OPCAP_CLIENT_Tests.cfg /data/OPCAP_CLIENT_Tests.cfg

CMD	ttcn3-docker-run pcap-client OPCAP_CLIENT_Tests