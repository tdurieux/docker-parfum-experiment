########## BUILDER ##########

FROM python:3.10-slim AS builder

RUN apt-get update \
	&& apt-get -y --no-install-recommends install \
		gcc \
		libpq-dev && rm -rf /var/lib/apt/lists/*;

RUN useradd -rm -d /home/pcapi -u 1000 pcapi

USER pcapi

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt ./

RUN pip install --no-cache-dir --user \
	--requirement ./requirements.txt

######### LIB ##########

FROM python:3.10-slim AS lib

RUN useradd -rm -d /home/pcapi -u 1000 pcapi

ENV PATH=$PATH:/home/pcapi/.local/bin

RUN apt-get update \
	&& apt-get --no-install-recommends -y install \
		libglib2.0-0 \
		libpango-1.0-0 \
		libpangoft2-1.0-0 \
		libpq5 \
		libxmlsec1-openssl \
		xmlsec1 && rm -rf /var/lib/apt/lists/*;

COPY --from=builder /home/pcapi/.local /home/pcapi/.local

USER pcapi

WORKDIR /usr/src/app

COPY --chown=pcapi:pcapi . .

######### DEV ##########

FROM lib AS api-flask

USER root

RUN apt-get update && \
    apt-get -y --no-install-recommends install postgresql-client && rm -rf /var/lib/apt/lists/*;

USER pcapi

RUN pip install --no-cache-dir --user -e .

######### PRODUCTION #########

FROM lib AS pcapi

WORKDIR /usr/src/app

RUN pip install \
		--no-cache-dir \
		--editable .

ENTRYPOINT exec ./entrypoint.sh

######### CONSOLE #########

FROM pcapi AS pcapi-console

USER root

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
		curl \
		git && rm -rf /var/lib/apt/lists/*;

RUN apt update && \
	apt install --no-install-recommends -y wget gnupg2 && \
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
	echo "deb http://apt.postgresql.org/pub/repos/apt/ `. /etc/os-release && echo $VERSION_CODENAME`-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
	apt update && apt -y --no-install-recommends install postgresql-client-12 && rm -rf /var/lib/apt/lists/*;

USER pcapi
