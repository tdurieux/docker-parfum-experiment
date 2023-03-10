FROM python:3.6-slim


    RUN apt-get update -qq && apt-get install --no-install-recommends -qqy curl openssh-client && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir pipenv

ENV TINI_VERSION v0.17.0
RUN set -ex; \
    curl -fsSL -o /tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini; \
    chmod +x /tini

RUN mkdir -p /src
WORKDIR /src

COPY Pipfile Pipfile.lock ./
RUN pipenv install --system --deploy

COPY src ./src/
COPY run ./

ARG BUILD_TIMESTAMP=0

RUN echo -n $BUILD_TIMESTAMP > ./src/plz/controller/BUILD_TIMESTAMP

HEALTHCHECK --interval=5s CMD curl -f http://localhost/

ENTRYPOINT ["/tini", "--", "./run"]
