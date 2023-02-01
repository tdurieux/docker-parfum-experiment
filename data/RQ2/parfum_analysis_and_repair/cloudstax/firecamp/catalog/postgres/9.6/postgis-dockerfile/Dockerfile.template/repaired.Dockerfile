FROM %%OrgName%%firecamp-postgres:9.6

RUN apt-get update \
	&& apt-get install --no-install-recommends -y postgis \
	&& rm -rf /var/lib/apt/lists/*
