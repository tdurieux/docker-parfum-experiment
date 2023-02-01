FROM debian:stable-slim as debian-python
RUN apt-get update && apt-get install --no-install-recommends -y gcc python3-dev python3-certifi python3-setuptools python3-coverage python3-wheel make && rm -rf /var/lib/apt/lists/*;
RUN useradd -ms /bin/bash buildout
USER buildout
RUN mkdir /home/buildout/sandbox
WORKDIR /home/buildout/sandbox
FROM debian-python
ARG PYTHON_VER
COPY doc /home/buildout/sandbox/doc
COPY src /home/buildout/sandbox/src
COPY zc.recipe.egg_ /home/buildout/sandbox/zc.recipe.egg_
COPY setup.* dev.py *.rst *.txt buildout.cfg .coveragerc /home/buildout/sandbox/
USER root
RUN chown -R buildout:buildout *
USER buildout
RUN python3 dev.py
COPY Makefile Makefile.* /home/buildout/sandbox/
