FROM nmt-models as models
FROM python:3.10.4-slim-bullseye

RUN apt-get update -y && apt-get upgrade -y && apt-get install --no-install-recommends gcc vim -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install python3-pip -y --no-install-recommends && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip && pip3 install --no-cache-dir --upgrade setuptools

COPY use-models-tools/requirements.txt /srv/
WORKDIR /srv
RUN pip3 install --no-cache-dir -r requirements.txt


COPY use-models-tools/*.py /srv/
COPY use-models-tools/segment.srx /srv/
COPY use-models-tools/docker/entry-point.sh /srv/



COPY --from=models /srv/models /srv/models

ENTRYPOINT /srv/entry-point.sh
#ENTRYPOINT bash
