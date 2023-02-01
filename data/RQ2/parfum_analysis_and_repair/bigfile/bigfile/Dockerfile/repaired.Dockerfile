FROM ubuntu

RUN apt-get install -y --no-install-recommends libgraphicsmagick1-dev && rm -rf /var/lib/apt/lists/*;

COPY bigfile /bigfile/

WORKDIR /bigfile

ENTRYPOINT ["/bigfile/bigfile"]