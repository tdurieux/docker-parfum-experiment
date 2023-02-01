FROM python:3.7

LABEL "repository"="https://github.com/sergioisidoro/github-transifex-action"
LABEL "homepage"="https://github.com/sergioisidoro/github-transifex-action"
LABEL "maintainer"="Sergio Isidoro <smaisidoro@gmail.com>"


RUN pip install --no-cache-dir transifex-client
RUN apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
