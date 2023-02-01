FROM python:3.9

USER root
RUN set -ex; apt-get -y update; apt-get -y --no-install-recommends install gcc && rm -rf /var/lib/apt/lists/*;
RUN set -ex; useradd sigopt; mkdir -p /sigopt
USER sigopt

COPY venv_requirements.txt /sigopt/venv_requirements.txt
RUN pip install --no-cache-dir --user -r /sigopt/venv_requirements.txt

COPY . /sigopt
WORKDIR /sigopt
