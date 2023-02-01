FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && \
    apt-get install --no-install-recommends -y python3.7 libpython3.7-dev python3.7-venv wget git python3.7-distutils && \
    apt-get install --no-install-recommends -y default-libmysqlclient-dev build-essential iputils-ping && rm -rf /var/lib/apt/lists/*;

RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python3.7 get-pip.py && \
    ln -s /usr/bin/python3.7 /usr/local/bin/python3

RUN mkdir /usr/src/bounty && rm -rf /usr/src/bounty
WORKDIR /usr/src/bounty

COPY ./bounty ./bounty
COPY ./tools   ./tools

RUN pip install --no-cache-dir -r ./bounty/requirements.txt

ENV PYTHONPATH="/usr/src/bounty"
CMD [ "python3", "./bounty/bounty_agent.py" ]
