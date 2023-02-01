FROM python:3.8.0-slim

WORKDIR /build
COPY . /build

RUN apt-get update \
    && apt-get install --no-install-recommends gcc -y \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install -r requirements.txt

# Install Tor
RUN apt-get install --no-install-recommends -y tor && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# These are Tor ports
EXPOSE 9050
EXPOSE 9150
EXPOSE 3002

ENTRYPOINT ["sh","/build/docker_launcher.sh"]
CMD ["""]