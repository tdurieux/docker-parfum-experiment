FROM jkcclemens/paste

RUN $HOME/.cargo/bin/cargo install diesel_cli --no-default-features --features postgres

RUN apt-get update && apt-get install -y --assume-yes --no-install-recommends postgresql-client \
	&& rm -rf /var/lib/apt/lists/* \
	&& apt-get clean

STOPSIGNAL SIGKILL

ADD run.sh /run.sh

CMD /run.sh
