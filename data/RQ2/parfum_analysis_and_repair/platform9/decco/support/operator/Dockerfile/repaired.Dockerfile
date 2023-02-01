FROM debian

ADD decco-operator /usr/local/bin/
RUN apt-get -y update && apt-get -y --no-install-recommends install ca-certificates && rm -rf /var/lib/apt/lists/*;
CMD ["decco-operator"]
