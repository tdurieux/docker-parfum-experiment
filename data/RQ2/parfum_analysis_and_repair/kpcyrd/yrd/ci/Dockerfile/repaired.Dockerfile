FROM ubuntu:16.04
RUN apt-get update -qq \
    && apt-get install --no-install-recommends -yq python3-nose \
        python3-argh python3-requests && rm -rf /var/lib/apt/lists/*;
COPY ./ /work
WORKDIR /work
CMD ["nosetests3", "-v", "yrd"]
