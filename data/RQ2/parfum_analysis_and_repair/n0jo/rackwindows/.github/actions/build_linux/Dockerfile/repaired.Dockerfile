FROM ubuntu:16.04

LABEL "com.github.actions.name"="VCVRackPluginBuilder-Linux"
LABEL "com.github.actions.description"="Builds a VCV Rack plugin for Linux"
LABEL "com.github.actions.icon"="headphones"
LABEL "com.github.actions.color"="purple"

LABEL "repository"="TBD"
LABEL "homepage"="TBD"
LABEL "maintainer"="n0jo"

RUN apt-get update && apt-get install --no-install-recommends -y build-essential cmake curl gcc g++ git make tar unzip zip libgl1-mesa-dev libglu1-mesa-dev jq && rm -rf /var/lib/apt/lists/*;

ADD entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
