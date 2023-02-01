FROM python:3.9

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y --no-install-recommends install git-annex && rm -rf /var/lib/apt/lists/*;

COPY . /tmp/build
RUN pip install --no-cache-dir /tmp/build
RUN rm -r /tmp/build

RUN adduser gituser

CMD [ "bash" ]
