FROM ubuntu
LABEL maintainer="Francesco Di Natale dinatale3@llnl.gov"

RUN apt-get update && apt-get install --no-install-recommends -y \
    python3 \
    python3-pip \
    git && rm -rf /var/lib/apt/lists/*;
ADD . /maestrowf
RUN python3 -m pip install -U /maestrowf
