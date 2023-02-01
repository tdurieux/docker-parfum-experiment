FROM node
RUN apt-get update && apt-get install --no-install-recommends -yq \
  redis-server \
  vim \
  && apt-get clean && rm -rf /var/lib/apt/lists/*;