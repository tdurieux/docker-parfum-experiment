FROM nucypher/rust-python:3.9.9
ENV PYTHONUNBUFFERED 1
ENV PYTHONPATH /code

# Update
RUN apt-get update -y && apt-get upgrade -y && apt-get install --no-install-recommends patch gcc libffi-dev wget git -y && rm -rf /var/lib/apt/lists/*;

# make an install directory
RUN mkdir /install
WORKDIR /install

# copy only the exact files needed for install into the container
COPY ./nucypher/__about__.py /install/nucypher/
COPY README.md /install
COPY setup.py /install
COPY ./nucypher/blockchain/eth/sol/__conf__.py /install/nucypher/blockchain/eth/sol/__conf__.py
COPY scripts/installation/install_solc.py /install/scripts/installation/
COPY dev-requirements.txt /install
COPY requirements.txt /install
COPY docs-requirements.txt /install
COPY dev/docker/scripts/install/entrypoint.sh /install

# install reqs and solc
RUN pip install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir .[dev] --src /usr/local/src
RUN pip3 install --no-cache-dir ipdb

# puts the nucypher executable in bin path
RUN python3 /install/setup.py develop

# now install solc
RUN python3 /install/scripts/installation/install_solc.py

# this gets called after volumes are mounted and so can modify the local disk
CMD ["/install/entrypoint.sh"]
