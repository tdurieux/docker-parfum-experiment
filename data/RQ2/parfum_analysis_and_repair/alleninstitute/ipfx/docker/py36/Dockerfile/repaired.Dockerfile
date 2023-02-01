FROM python:3.6

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        hdf5-tools \
        curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash

RUN apt-get install -y --no-install-recommends git-lfs && rm -rf /var/lib/apt/lists/*;
