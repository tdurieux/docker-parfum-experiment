# TESTING - DO NOT USE
FROM node:12-buster-slim AS builder

RUN apt-get update
RUN apt-get install --no-install-recommends -y git python3 build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-pandas && rm -rf /var/lib/apt/lists/*;
RUN npm ci --production

FROM node:12-buster-slim

RUN python -m pip install --upgrade pip

WORKDIR /build

COPY . /build

RUN python -m pip install Cython
RUN python -m pip install pysocks
RUN python -m pip install -r requirements.txt

# This is the port that WARden runs from
EXPOSE 5000

# Install Tor
RUN apt-get install --no-install-recommends -y tor && rm -rf /var/lib/apt/lists/*;

# These are Tor ports
EXPOSE 9050
EXPOSE 9150

ENTRYPOINT ["/app/docker_launcher.sh"]
CMD [""]

