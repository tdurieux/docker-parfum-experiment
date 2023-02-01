FROM r-base:4.1.3
WORKDIR /opt/src
RUN apt-get update -y && apt-get install --no-install-recommends -y make gawk curl unzip libncurses5-dev procps libncursesw5-dev && rm -rf /var/lib/apt/lists/*;
RUN wget https://wonder.cdc.gov/amd/flu/irma/flu-amd.zip \
    && unzip flu-amd.zip
RUN apt-get install --no-install-recommends -y libncurses5 && rm -rf /var/lib/apt/lists/*;
SHELL ["/bin/bash", "--login", "-c"]
ENV PATH="/opt/src/flu-amd:${PATH}"
