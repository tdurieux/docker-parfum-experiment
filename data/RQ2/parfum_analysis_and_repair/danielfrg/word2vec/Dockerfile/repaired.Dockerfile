FROM conda/miniconda3

RUN apt-get update && apt-get install --no-install-recommends -y make git curl unzip build-essential && rm -rf /var/lib/apt/lists/*;

COPY environment.yml /tmp/environment.yml
RUN conda env create -f /tmp/environment.yml
RUN conda init bash

VOLUME /workdir
WORKDIR /workdir
