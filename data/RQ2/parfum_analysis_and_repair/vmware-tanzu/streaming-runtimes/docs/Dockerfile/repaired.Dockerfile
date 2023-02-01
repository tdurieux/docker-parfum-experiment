FROM python:3-alpine

ARG USER=1001

RUN adduser -h /usr/src/mkdocs -D -u $USER mkdocs \
&& apk add --no-cache bash \
&& apk add --no-cache git

ENV PATH="${PATH}:/usr/src/mkdocs/.local/bin"

USER mkdocs
RUN mkdir -p /usr/src/mkdocs/build && rm -rf /usr/src/mkdocs/build
WORKDIR /usr/src/mkdocs/build

RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir pymdown-extensions \
&& pip install --no-cache-dir mkdocs \
&& pip install --no-cache-dir mkdocs-material \
&& pip install --no-cache-dir mkdocs-rtd-dropdown \
&& pip install --no-cache-dir mkdocs-git-revision-date-plugin \
&& pip install --no-cache-dir mkdocs-git-revision-date-localized-plugin

COPY ./streaming-runtime-samples ./streaming-runtime-samples
COPY ./material ./material
COPY mkdocs.yml .

EXPOSE 8000

ENTRYPOINT ["mkdocs", "serve"]
