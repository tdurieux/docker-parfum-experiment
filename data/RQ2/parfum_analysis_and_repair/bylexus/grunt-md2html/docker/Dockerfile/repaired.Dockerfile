FROM node:12-stretch

RUN apt-get update && apt-get install --no-install-recommends -y \
    graphviz \
    plantuml \
    make \
    gcc \
    g++ && rm -rf /var/lib/apt/lists/*;
