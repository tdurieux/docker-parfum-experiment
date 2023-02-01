USER root

# more build dependencies
RUN apt-get -y update && apt-get install --no-install-recommends \
curl \




-y && rm -rf /var/lib/apt/lists/*;

USER steam
