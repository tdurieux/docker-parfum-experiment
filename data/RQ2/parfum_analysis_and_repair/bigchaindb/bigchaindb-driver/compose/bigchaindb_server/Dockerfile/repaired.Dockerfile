FROM python:3.6

RUN apt-get update && apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;

ARG branch
ARG backend
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

RUN pip install --no-cache-dir --upgrade pip ipdb ipython

COPY . /usr/src/app/
ENV BIGCHAINDB_DATABASE_BACKEND "${backend}"
RUN pip install --no-cache-dir git+https://github.com/bigchaindb/bigchaindb.git@"${branch}"#egg=bigchaindb
