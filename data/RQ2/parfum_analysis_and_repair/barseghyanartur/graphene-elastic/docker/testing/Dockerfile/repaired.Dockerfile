FROM python:3.6.8-slim-jessie
ENV PYTHONUNBUFFERED 1

RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y mc && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nano && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir pip --upgrade
RUN pip3 install --no-cache-dir virtualenv

RUN mkdir /code
WORKDIR /code
ADD pytest.ini /code/pytest.ini
ADD runtests.py /code/runtests.py
ADD requirements.txt /code/requirements.txt
ADD requirements/ /code/requirements/
ADD scripts/ /code/scripts/
ADD docker/ /code/docker/
RUN pip3 install --no-cache-dir -r /code/requirements.txt
#COPY ./docker /code/docker/
