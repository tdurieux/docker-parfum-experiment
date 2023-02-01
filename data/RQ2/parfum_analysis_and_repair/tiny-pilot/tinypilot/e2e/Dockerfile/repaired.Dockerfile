FROM mtlynch/debian10-ansible:2.9.13

RUN apt-get update && \
    apt-get install --no-install-recommends \
      -y \
      curl \
      git && rm -rf /var/lib/apt/lists/*;

# TCP protocol is missing for some reason in test image, so we need to
# reinstall it.
RUN apt-get -o Dpkg::Options::="--force-confmiss" -y --no-install-recommends install \
      --reinstall netbase && rm -rf /var/lib/apt/lists/*;
