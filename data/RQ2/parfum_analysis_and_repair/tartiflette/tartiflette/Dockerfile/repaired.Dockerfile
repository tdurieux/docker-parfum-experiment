FROM python:3.7.4

RUN apt-get update && apt-get install --no-install-recommends -y cmake git jq && rm -rf /var/lib/apt/lists/*;

ENV PYTHONPATH=/usr/src/app/

WORKDIR /usr/src/app

COPY . /usr/src/app/

RUN make init
RUN pip install --no-cache-dir -e .[test]
