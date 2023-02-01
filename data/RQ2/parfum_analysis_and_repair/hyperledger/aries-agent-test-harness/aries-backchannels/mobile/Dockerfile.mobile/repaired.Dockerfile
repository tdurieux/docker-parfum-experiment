FROM python:3.7-buster
RUN mkdir -p /aries-backchannels
WORKDIR /aries-backchannels

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CE7709D068DB5E88 \
   && apt-get update \
   && apt-get install --no-install-recommends -y software-properties-common \
   && apt-get update && rm -rf /var/lib/apt/lists/*;

ENV RUNMODE=docker

COPY python/requirements.txt python/
RUN pip install --no-cache-dir -r python/requirements.txt
COPY mobile/requirements.txt mobile/
RUN pip install --no-cache-dir -r mobile/requirements.txt

# Copy the necessary files from the AATH Backchannel sub-folders
COPY python python
COPY mobile mobile
COPY data ./

ENV PYTHONPATH=/aries-backchannels

ENTRYPOINT ["python", "mobile/mobile_backchannel.py"]
