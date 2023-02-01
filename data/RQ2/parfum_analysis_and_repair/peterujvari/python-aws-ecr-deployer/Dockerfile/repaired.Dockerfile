FROM ubuntu:14.04

ENV LC_CTYPE C.UTF-8

RUN apt-get update && apt-get install --no-install-recommends -y --force-yes \
    python-software-properties \
    git \
    curl && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y --force-yes software-properties-common && \
    add-apt-repository ppa:fkrull/deadsnakes && \
    apt-get update && \
    apt-get -y --no-install-recommends --force-yes install python3.5-complete && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y build-essential python-dev && rm -rf /var/lib/apt/lists/*;

RUN python3.5 -m ensurepip && pip3.5 install gunicorn==19.4.0

WORKDIR /srv

ADD requirements.txt ./

RUN pip3.5 install --upgrade -r requirements.txt

ADD serve.py .coveragerc .dockerignore gunicorn.py ./

ADD data data
ADD config config
ADD deployer deployer
ADD tasks tasks
ADD tests tests

RUN chmod +x serve.py

CMD ["gunicorn", "--log-file=-", "-c", "/srv/gunicorn.py", "serve:app"]
