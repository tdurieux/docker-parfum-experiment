FROM ubuntu
RUN apt-get update
RUN apt-get install --no-install-recommends jq -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
