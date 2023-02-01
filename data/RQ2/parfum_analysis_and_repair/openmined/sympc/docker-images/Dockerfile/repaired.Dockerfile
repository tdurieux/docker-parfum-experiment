FROM python:3.7-slim-buster

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y --no-install-recommends install git clang build-essential && rm -rf /var/lib/apt/lists/*;

COPY ./ SyMPC/

WORKDIR /SyMPC

RUN pip3 install --no-cache-dir setuptools_scm
RUN pip3 install --no-cache-dir -r requirements.txt && pip3 install --no-cache-dir -r requirements.dev.txt
RUN pip3 install --no-cache-dir -e .

ENTRYPOINT [ "/bin/bash" ]
