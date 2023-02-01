FROM ubuntu:18.04

LABEL maintainer="andrewnijmeh1@gmail.com"
LABEL description="Disassembling the EVM."

COPY . /evm
WORKDIR /evm

RUN apt-get upgrade
RUN apt-get update && apt-get -y --no-install-recommends install gcc g++ git curl python-dev python-virtualenv && rm -rf /var/lib/apt/lists/*;
# Make sure to install pip3
RUN apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;

RUN virtualenv venv
RUN bash -c "source venv/bin/activate && pip3 install --upgrade pip"

COPY ../requirements.txt ../requirements.txt
RUN bash -c "source venv/bin/activate && pip3 install --upgrade -r requirements.txt"

RUN ln -sf /evm/evm /usr/local/bin/evm

COPY . .

RUN ./run_tests.sh
