FROM debian:stable-slim as debian-python
RUN apt-get update && apt-get install --no-install-recommends -y make gcc openssl libffi-dev curl zlib1g-dev libssl-dev libsqlite3-dev && rm -rf /var/lib/apt/lists/*;
RUN useradd -ms /bin/bash buildout
USER buildout
ARG PYTHON_VER
ENV LANG C.UTF-8
RUN mkdir /home/buildout/sandbox
WORKDIR /home/buildout/sandbox
COPY Makefile Makefile.configure /home/buildout/sandbox/
RUN make PYTHON_VER=${PYTHON_VER} download_python
RUN make PYTHON_VER=${PYTHON_VER} python
FROM debian-python
ARG PYTHON_VER
COPY doc /home/buildout/sandbox/doc
COPY src /home/buildout/sandbox/src
COPY zc.recipe.egg_ /home/buildout/sandbox/zc.recipe.egg_
COPY setup.* dev.py *.rst *.txt buildout.cfg .coveragerc /home/buildout/sandbox/
USER root
RUN chown -R buildout:buildout *
USER buildout
RUN make PYTHON_VER=${PYTHON_VER} build
COPY Makefile.builds /home/buildout/sandbox/
