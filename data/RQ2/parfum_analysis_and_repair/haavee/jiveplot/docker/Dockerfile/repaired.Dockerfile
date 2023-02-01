FROM kernsuite/base:4
SHELL ["/bin/bash", "-c"]
# Allow to specify the jiveplot branch at build time of the image.
# Use master as the default if nothing is specified.
ARG JIVEPLOT_VERSION=latest
ENV JIVEPLOT_VERSION=${JIVEPLOT_VERSION}

RUN apt-get update && apt-get install --no-install-recommends --fix-missing -y git && rm -rf /var/lib/apt/lists/*;
RUN docker-apt-install python-casacore ppgplot
RUN cd /usr/local/ && git clone --depth 1 --shallow-submodules --branch ${JIVEPLOT_VERSION//latest/master} https://github.com/haavee/jiveplot.git

ENTRYPOINT ["/usr/local/jiveplot/jplotter"]
