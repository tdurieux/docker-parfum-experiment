FROM ubuntu:14.04
RUN apt-get update && apt-get install -y --no-install-recommends -qq nodejs && rm -rf /var/lib/apt/lists/*;
ADD cwl-engine.js /usr/local/bin/
