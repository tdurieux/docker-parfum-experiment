FROM python:3

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y git jupyter python3-pandas python3-yaml cowsay && rm -rf /var/lib/apt/lists/*;

ENV PATH $PATH:/usr/games

COPY entrypoint.sh /opt/entrypoint.sh

ENTRYPOINT [ "/opt/entrypoint.sh" ]
