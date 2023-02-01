FROM nginx:latest

RUN apt-get update && apt-get install --no-install-recommends -y \
  curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf ~/.cache/pip
