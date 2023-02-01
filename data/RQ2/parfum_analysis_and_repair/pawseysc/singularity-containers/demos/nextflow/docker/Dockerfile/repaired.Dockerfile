FROM continuumio/miniconda:4.7.12
MAINTAINER Paolo Di Tommaso <paolo.ditommaso@gmail.com>

RUN apt-get -y --no-install-recommends install ttf-dejavu && rm -rf /var/lib/apt/lists/*;

COPY conda.yml .
RUN \
   conda env update -n root -f conda.yml \
&& conda clean -a

RUN apt-get install --no-install-recommends -y procps && rm -rf /var/lib/apt/lists/*;

