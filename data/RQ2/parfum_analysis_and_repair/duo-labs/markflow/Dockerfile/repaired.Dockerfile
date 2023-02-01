FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get -y upgrade

RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y python3.6 python3.7 python3.8 python-3.9 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3.6-venv python3.7-venv python3.8-venv python3.9-venv && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/bin/python3 /usr/bin/python

RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python

ENV PATH="/root/.poetry/bin:${PATH}"

RUN apt-get install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;

# Setup our virtual environments. Sure the intermediate layers are large, but this
# doesn't change often, and can take a while.
#ADD pyproject.toml /src/
#ADD poetry.lock /src/
#WORKDIR /src
#RUN poetry env use 3.6 && poetry install && \
#    poetry env use 3.7 && poetry install && \
#    poetry env use 3.8 && poetry install && \
#    rm -rf /src
