FROM docker.io/python:3.9-slim-bullseye
ENV PYTHONUNBUFFERED 1

RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;
#RUN apt-get install -y python-dev
#RUN apt-get install -y python-pip
#RUN apt-get install -y python-imaging
RUN apt-get install --no-install-recommends -y mc && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nano && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir pip --upgrade
RUN pip install --no-cache-dir virtualenv

RUN mkdir /backend
WORKDIR /backend
ADD examples/requirements/ /backend/requirements/
RUN pip install --no-cache-dir -r /backend/requirements/dev.txt
RUN pip install --no-cache-dir -r /backend/requirements/elastic_docker.txt
COPY . /backend/
RUN python /backend/setup.py develop
