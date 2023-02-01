FROM python:3.7
# Set up code directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app

# Install deps
RUN apt-get update && apt-get -y --no-install-recommends install libsnappy-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install -e .[dev]  --no-cache-dir
RUN pip install -U trinity --no-cache-dir

RUN echo "Type \`trinity\` to boot or \`trinity --help\` for an overview of commands"

EXPOSE 30303 30303/udp
ENTRYPOINT ["trinity"]
