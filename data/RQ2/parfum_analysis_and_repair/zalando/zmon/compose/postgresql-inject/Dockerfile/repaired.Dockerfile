FROM ubuntu:16.04
RUN apt-get -y update && apt-get -y --no-install-recommends install git postgresql-client bash wget unzip && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p workdir
COPY inject.sh /inject.sh
CMD ["bash","-x","/inject.sh"]
