FROM python:3.7.2-stretch AS build

COPY /sdk/ /src/sdk/
COPY /cli/ /src/cli/

ARG version

RUN echo $version > /src/sdk/VERSION \
    && echo $version > /src/cli/VERSION \
    && mkdir /dist \
    && cd /src/sdk/ \
    && python setup.py bdist_wheel --universal -d /dist \
    && cd /src/cli/ \
    && python setup.py bdist_wheel --universal -d /dist

FROM python:3.7.2-stretch

RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    zip \
    inotify-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /dist /dist
RUN pip install --no-cache-dir $(ls /dist/kamonohashi_sdk*) \
    && pip install --no-cache-dir $(ls /dist/kamonohashi_cli*)