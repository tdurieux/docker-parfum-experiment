FROM python:3.7
# Set up code directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Install deps
RUN apt-get update && apt-get -y --no-install-recommends install libsnappy-dev gcc g++ cmake && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/ethereum/trinity-eth2.git .
RUN pip install -e .[dev] --no-cache-dir

RUN echo "Type \`trinity-beacon\` to boot or \`trinity-beacon --help\` for an overview of commands"

EXPOSE 30303 30303/udp
ENTRYPOINT ["trinity-beacon"]
