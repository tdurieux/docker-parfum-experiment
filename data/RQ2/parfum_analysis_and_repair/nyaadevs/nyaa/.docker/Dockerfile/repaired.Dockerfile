FROM ubuntu:18.04

ENV LANG=en_US.utf-8 LC_ALL=en_US.utf-8 DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update

COPY ./ /nyaa/
RUN cat /nyaa/config.example.py /nyaa/.docker/nyaa-config-partial.py > /nyaa/config.py

# Requirements for running the Flask app
RUN apt-get -y --no-install-recommends install build-essential git python3 python3-pip libmysqlclient-dev curl && rm -rf /var/lib/apt/lists/*;
# Helpful stuff for the docker entrypoint.sh script
RUN apt-get -y --no-install-recommends install mariadb-client netcat && rm -rf /var/lib/apt/lists/*;

WORKDIR /nyaa
RUN pip3 install --no-cache-dir -r requirements.txt

CMD ["/nyaa/.docker/entrypoint.sh"]
