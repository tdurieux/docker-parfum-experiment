FROM docker/whalesay:latest
RUN apt-get -y update && apt-get install --no-install-recommends -y git python-gnupg libgmp-dev python-pip python-dev curl libcurl4-openssl-dev libssl-dev libpth-dev libffi-dev python-cffi libsodium-dev && rm -rf /var/lib/apt/lists/*;
RUN echo 'done'
RUN pwd
RUN git clone https://github.com/flipchan/LayerProx.git
