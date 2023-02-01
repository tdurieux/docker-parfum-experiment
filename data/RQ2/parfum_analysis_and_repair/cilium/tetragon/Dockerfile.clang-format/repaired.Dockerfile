FROM ubuntu:22.04

RUN apt-get -y update && apt-get -y --no-install-recommends install clang-format-14 && rm -rf /var/lib/apt/lists/*;
RUN ln -s /bin/clang-format-14 /bin/clang-format

USER 1000
WORKDIR /tetragon

ENTRYPOINT ["clang-format"]
CMD ["--help"]
