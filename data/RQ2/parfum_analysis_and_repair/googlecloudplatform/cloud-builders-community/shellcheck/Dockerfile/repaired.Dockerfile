FROM launcher.gcr.io/google/ubuntu1804
LABEL MAINTAINER marcin.niemira@gmail.com

RUN apt-get update && \
    apt-get -y --no-install-recommends install shellcheck && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["shellcheck"]
