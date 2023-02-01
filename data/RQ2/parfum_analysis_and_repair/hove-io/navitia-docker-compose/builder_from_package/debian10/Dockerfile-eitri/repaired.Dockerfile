FROM navitia/master

# copy package from context inside the docker
COPY navitia-ed_*.deb /
COPY navitia/source/ /navitia/source/

# install dependencies
RUN apt-get update \
    && apt-get install --no-install-recommends -y python3 python3-pip libpq-dev jq git zip curl \
    && apt-get install --no-install-recommends -y /navitia-ed_*.deb \
    && apt-get clean \
    && rm -rf /navitia-ed_*.deb && rm -rf /var/lib/apt/lists/*;

# install eitri requirements
RUN pip3 install --no-cache-dir -r /navitia/source/eitri/requirements.txt
