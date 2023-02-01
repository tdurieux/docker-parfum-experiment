FROM ubuntu:18.04 as curl

RUN apt-get update && apt-get install --no-install-recommends -yq curl && vim git apt-get clean && rm -rf /var/lib/apt/lists/*;

FROM curl as klayout1

RUN \
    curl -f -o /klayout_0.25.4-1_amd64.deb https://www.klayout.org/downloads/Ubuntu-18/klayout_0.25.4-1_amd64.deb

FROM klayout1 as klayout

RUN \
    apt-get install --no-install-recommends -yq /klayout_0.25.4-1_amd64.deb && rm -rf /var/lib/apt/lists/*;
