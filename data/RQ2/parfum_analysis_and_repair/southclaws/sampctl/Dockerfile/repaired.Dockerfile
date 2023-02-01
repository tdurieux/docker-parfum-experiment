FROM ubuntu
COPY sampctl /bin/sampctl
RUN mkdir samp && \
    dpkg --add-architecture i386 && \
    apt update && \
    apt install --no-install-recommends -y g++-multilib git ca-certificates && rm -rf /var/lib/apt/lists/*;
WORKDIR /samp
ENTRYPOINT ["sampctl"]
