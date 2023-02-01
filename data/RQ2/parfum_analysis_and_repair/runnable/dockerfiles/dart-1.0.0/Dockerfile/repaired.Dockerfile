FROM stackbrew/ubuntu:saucy
MAINTAINER runnable.com <support@runnable.com>

# REPOS
RUN apt-get -y update
RUN apt-get install --no-install-recommends -y -q software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get -y update

# EDITORS
RUN apt-get install --no-install-recommends -y -q vim nano && rm -rf /var/lib/apt/lists/*;

## APACHE
RUN apt-get install --no-install-recommends -y -q apache2 && rm -rf /var/lib/apt/lists/*;

# TOOLS
RUN apt-get install --no-install-recommends -y -q curl git make wget unzip && rm -rf /var/lib/apt/lists/*;

# BUILD
RUN apt-get install --no-install-recommends -y -q build-essential g++ && rm -rf /var/lib/apt/lists/*;

# LANGS

## NODE
RUN apt-get install --no-install-recommends -y -q nodejs && rm -rf /var/lib/apt/lists/*;

## DART
ADD dart-sdk /
## CONFIG
ENV RUNNABLE_USER_DIR /root
ENV RUNNABLE_START_CMD dart server.dart

