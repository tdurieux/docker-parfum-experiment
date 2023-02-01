FROM ubuntu:21.04

USER root

ENV DEBIAN_FRONTEND=noninteractive

# Install some essentials
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    libboost-all-dev \
    curl && rm -rf /var/lib/apt/lists/*;

# Install python3
RUN apt-get install --no-install-recommends python3-dev python3-pip -y && rm -rf /var/lib/apt/lists/*;

# Install souffle
RUN curl -f -s https://packagecloud.io/install/repositories/souffle-lang/souffle/script.deb.sh | bash
RUN apt-get update && apt-get install --no-install-recommends souffle -y && rm -rf /var/lib/apt/lists/*;

# Dependencies for Gigahorse output viz
RUN apt-get update && apt-get install --no-install-recommends -y graphviz && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install pydot

# Set up a non-root 'gigahorse' user
RUN groupadd -r gigahorse && useradd -ms /bin/bash -g gigahorse gigahorse

RUN mkdir -p /opt/gigahorse/gigahorse-toolchain

# Copy gigahorse project root
COPY . /opt/gigahorse/gigahorse-toolchain/

RUN chown -R gigahorse:gigahorse /opt/gigahorse
RUN chmod -R o+rwx /opt/gigahorse

# Switch to new 'gigahorse' user context
USER gigahorse

# Souffle-addon bare-minimum make
RUN cd /opt/gigahorse/gigahorse-toolchain/souffle-addon && make libsoufflenum.so

CMD ["-h"]
ENTRYPOINT ["/opt/gigahorse/gigahorse-toolchain/gigahorse.py"]
