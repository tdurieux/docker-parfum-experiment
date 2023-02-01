# Pin syntax as Docker reccomens
# https://docs.docker.com/language/python/build-images/#create-a-dockerfile-for-python
FROM python:3.9-slim

RUN apt-get update && apt-get -y --no-install-recommends install git graphviz make libpq-dev gcc && \
    curl -f -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash \
    && apt-get install -y --no-install-recommends git-lfs && git lfs install && apt clean && apt-get autoclean && apt-get autoremove && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/base

# small hack to not keep building all the time
COPY ./setup.py ./
COPY ./README.md ./
COPY ./lineapy/__init__.py ./lineapy/
COPY ./requirements.txt ./
COPY ./airflow-requirements.txt ./
COPY ./Makefile ./

ENV AIRFLOW_HOME=/usr/src/airflow_home
ENV AIRFLOW_VENV=/usr/src/airflow_venv

#RUN mkdir /usr/src/airflow_home
RUN pip --disable-pip-version-check --no-cache-dir install -r requirements.txt && make airflow_venv && pip cache purge

COPY . .

RUN python setup.py install && rm -rf build

CMD [ "lineapy" ]
