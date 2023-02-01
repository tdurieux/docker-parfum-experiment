FROM python:slim

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

LABEL "com.github.actions.name"="Placeholder for collecting jobs together"
LABEL "com.github.actions.description"=""
LABEL "com.github.actions.icon"="flag"
LABEL "com.github.actions.color"="green"

LABEL "repository"="http://github.com/stestagg/pytubes"
LABEL "homepage"="http://github.com/stestagg/pytubes"
LABEL "maintainer"="Stestagg <stestagg@gmail.com>"


ENTRYPOINT ["/bin/true"]