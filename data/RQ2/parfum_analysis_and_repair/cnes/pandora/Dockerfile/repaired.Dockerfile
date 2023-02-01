FROM ubuntu:20.04
RUN apt-get update && apt-get -y update
RUN apt-get install --no-install-recommends -y build-essential python3.6 python3-pip python3-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 -q --no-cache-dir install pip --upgrade

COPY notebooks/notebook_requirements.txt ./

RUN pip3 install --no-cache-dir --no-cache notebook && \
    pip3 install --no-cache-dir numpy && \
    pip3 install --no-cache-dir -r notebook_requirements.txt


ARG NB_USER=user
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}


USER $NB_USER

COPY --chown=1000:100 . Pandora

WORKDIR /Pandora