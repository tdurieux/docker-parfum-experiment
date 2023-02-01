FROM python:3.8

RUN apt-get update && apt-get install --no-install-recommends -y fonts-liberation && rm -rf /var/lib/apt/lists/*;

COPY ./dist /install_temp/dist

WORKDIR /install_temp
RUN pip install --no-cache-dir dist/*.whl

RUN rm -rf /install_temp

RUN groupadd connect && useradd -g connect -d /home/connect -s /bin/bash connect

USER connect

WORKDIR /home/connect
