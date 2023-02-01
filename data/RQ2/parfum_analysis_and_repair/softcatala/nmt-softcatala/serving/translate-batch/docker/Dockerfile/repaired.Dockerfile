FROM python:3.10.4-slim-bullseye as copied_files

COPY serving/translate-batch/requirements.txt /srv/
COPY serving/translate-batch/*.py /srv/
COPY serving/translate-batch/segment.srx /srv/
COPY serving/translate-batch/docker/entry-point.sh /srv/

FROM nmt-models as models

FROM python:3.10.4-slim-bullseye

RUN apt-get update -y && apt-get upgrade -y && apt-get install --no-install-recommends gcc -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install python3-pip -y --no-install-recommends && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip && pip3 install --no-cache-dir --upgrade setuptools

COPY --from=copied_files /srv/ /srv/
COPY --from=models /srv/models /srv/models

WORKDIR /srv
RUN pip3 install --no-cache-dir -r requirements.txt

ENTRYPOINT /srv/entry-point.sh
#ENTRYPOINT bash
