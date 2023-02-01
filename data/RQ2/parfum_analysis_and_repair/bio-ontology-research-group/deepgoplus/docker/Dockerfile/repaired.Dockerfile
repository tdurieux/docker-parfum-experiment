FROM python:3.6

RUN wget https://github.com/bbuchfink/diamond/releases/download/v2.0.2/diamond-linux64.tar.gz && tar xzf diamond-linux64.tar.gz && rm diamond-linux64.tar.gz
RUN mv diamond /usr/bin/

RUN pip install --no-cache-dir pip --upgrade
RUN pip install --no-cache-dir deepgoplus
