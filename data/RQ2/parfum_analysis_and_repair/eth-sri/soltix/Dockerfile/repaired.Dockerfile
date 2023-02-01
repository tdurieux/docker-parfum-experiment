FROM ubuntu:18.10

RUN rm /var/lib/apt/lists/* -vf
RUN apt-get update && apt-get dist-upgrade -y

RUN apt-get -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install npm && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN npm install -g n && npm cache clean --force;
RUN n stable

# TODO document openjdk usage
RUN apt-get -y --no-install-recommends install --fix-missing openjdk-11-jdk && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install maven && rm -rf /var/lib/apt/lists/*;

WORKDIR /soltix
COPY . /soltix

RUN ./setup.sh --use-defaults

ENTRYPOINT ["/soltix/docker-entrypoint.sh"]
