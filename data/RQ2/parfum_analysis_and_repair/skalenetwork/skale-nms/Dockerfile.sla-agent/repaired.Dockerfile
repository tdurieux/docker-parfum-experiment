FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && \
    apt-get install --no-install-recommends -y python3.7 libpython3.7-dev python3.7-venv wget git python3.7-distutils && \
    apt-get install --no-install-recommends -y default-libmysqlclient-dev build-essential iputils-ping && rm -rf /var/lib/apt/lists/*;

RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python3.7 get-pip.py && \
    ln -s /usr/bin/python3.7 /usr/local/bin/python3

RUN mkdir /usr/src/sla && rm -rf /usr/src/sla
WORKDIR /usr/src/sla

COPY ./sla ./sla
COPY ./tools   ./tools

RUN pip install --no-cache-dir -r ./sla/requirements.txt

ENV PYTHONPATH="/usr/src/sla"
CMD [ "python3", "./sla/sla_agent.py" ]
