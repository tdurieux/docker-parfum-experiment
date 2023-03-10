FROM python:3.7-slim

RUN apt-get update \
   && apt-get install --no-install-recommends -y git gnupg2 software-properties-common curl \
   && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CE7709D068DB5E88 \
   && add-apt-repository 'deb https://repo.sovrin.org/sdk/deb bionic stable' \
   && apt-get update \
   && apt-get install --no-install-recommends -y libindy libnullpay && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /aries-backchannels
WORKDIR /aries-backchannels

ADD https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 ./jq
RUN chmod +x ./jq

COPY python/requirements.txt python/
COPY acapy/requirements-main.txt acapy/
RUN pip install --no-cache-dir -r python/requirements.txt -r

# Copy the necessary files from the AATH Backchannel sub-folders
COPY python python
COPY acapy acapy
COPY data ./

# aca-py is in /usr/local/bin. The Backchannel is looking for it in ./bin, create a link to it in ./bin
RUN mkdir -p ./bin
RUN ln -s /usr/local/bin/aca-py ./bin/aca-py

ENV PYTHONPATH=/aries-backchannels
ENV RUNMODE=docker

RUN ./bin/aca-py --version > ./acapy-version.txt

ENTRYPOINT ["bash", "acapy/ngrok-wait.sh"]
