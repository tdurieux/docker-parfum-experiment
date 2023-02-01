FROM python:3.8

COPY requirements.txt /

RUN apt-get update \
 && apt-get install --no-install-recommends -y \
 wget \
 python3-dev \
 graphviz \
 libgraphviz-dev \
 pkg-config && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir -r requirements.txt && pip3 install --no-cache-dir gunicorn

ARG HASURA_GRAPHQL_ADMIN_SECRET
ARG HASURA_GRAPHQL_API
ARG SECRET_KEY
ARG FLASK_ENV
ARG CLIENT_HASURA_GRAPHQL_API

WORKDIR flask
ADD . /flask/


CMD [ "gunicorn", "--workers=4", "--threads=1", "-b 0.0.0.0:8050", "atlas:server"]
