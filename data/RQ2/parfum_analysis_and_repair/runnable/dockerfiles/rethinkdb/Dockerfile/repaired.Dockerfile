FROM boxcar/raring

RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:rethinkdb/ppa
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get -y update

# EDITORS
RUN apt-get install --no-install-recommends -y -q vim nano && rm -rf /var/lib/apt/lists/*;

# TOOLS
RUN apt-get install --no-install-recommends -y -q curl git make wget && rm -rf /var/lib/apt/lists/*;

# BUILD
RUN apt-get install --no-install-recommends -y -q build-essential g++ && rm -rf /var/lib/apt/lists/*;

# LANGS

## NODE
RUN apt-get install --no-install-recommends -y -q nodejs && rm -rf /var/lib/apt/lists/*;

# SERVICES

## RETHINK
RUN apt-get install --no-install-recommends -y -q rethinkdb && rm -rf /var/lib/apt/lists/*;

## CONFIG

ENV RUNNABLE_START_CMD rethinkdb --bind all --http-port 80
