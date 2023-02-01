FROM tensorflow/tensorflow:1.14.0-py3

LABEL version="0.0.1-beta"

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# for setup local mirror
RUN apt-get update && apt-get install --no-install-recommends -y \
    apt-transport-https \
    ca-certificates \
    apt-utils && rm -rf /var/lib/apt/lists/*;

# setup local mirror
COPY docker/build_base_image/sources.list  /etc/apt/sources.list

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y locales && rm -rf /var/lib/apt/lists/*;
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN pip3 install --no-cache-dir git+https://github.com/howl-anderson/ioflow.git

ADD ./ /temp/seq2annotation
RUN pip3 install --no-cache-dir /temp/seq2annotation

ENV HEALTH_CHECK_TRANSPONDER_PORT=9998

EXPOSE 9998

HEALTHCHECK --interval=5s --timeout=3s CMD curl --fail http://localhost:9998/ping || exit 1
