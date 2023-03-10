FROM python:slim

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

LABEL "com.github.actions.name"="Run shell script with useful python version"
LABEL "com.github.actions.description"=""
LABEL "com.github.actions.icon"="terminal"
LABEL "com.github.actions.color"="red"

LABEL "repository"="http://github.com/stestagg/pytubes"
LABEL "homepage"="http://github.com/stestagg/pytubes"
LABEL "maintainer"="Stestagg <stestagg@gmail.com>"


ADD requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]