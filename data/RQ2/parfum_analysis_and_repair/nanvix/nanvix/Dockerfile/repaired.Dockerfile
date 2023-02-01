FROM ubuntu:xenial
ADD tools/dev /tmp/tools/dev/
RUN apt-get update && apt-get install --no-install-recommends -y make wget tar bzip2 gzip patch && cd /tmp/ && bash tools/dev/setup-toolchain.sh && bash tools/dev/setup-bochs.sh && rm -Rvf /tmp/tools && rm -rf /var/lib/apt/lists/*;
ENV TARGET i386-elf
ENV PATH $PATH:/usr/local/cross/bin
VOLUME /code
EXPOSE 1234
WORKDIR /code
ENTRYPOINT ["bash"]
