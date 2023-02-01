FROM debian:buster-slim

WORKDIR /build
COPY . /build


RUN apt-get update
RUN apt-get install --no-install-recommends -y git python3 build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-numpy && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-pandas && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install Cython
RUN python3 -m pip install pysocks
RUN python3 -m pip install -r requirements.txt

# Install Tor
RUN apt-get install --no-install-recommends -y tor && rm -rf /var/lib/apt/lists/*;

# This is the port that WARden runs from
EXPOSE 5000

# These are Tor ports
EXPOSE 9050
EXPOSE 9150

ENTRYPOINT ["sh","/build/docker_launcher.sh"]
CMD [""]

