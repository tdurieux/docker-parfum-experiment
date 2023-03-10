FROM ubuntu:14.04

RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common python python-dev python-pip libffi-dev libpq-dev git-core postgresql-client \
    && apt-get clean \
    && apt-get autoclean \
    && sudo apt-get autoremove -y \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ && rm -rf /var/lib/apt/lists/*;

ADD . /opt/code
WORKDIR /opt/code

RUN pip install --no-cache-dir -r requirements.pip
RUN python setup.py develop

VOLUME ["/opt/code"]

EXPOSE 5000

CMD ["python", "/opt/code/{{PROJECT_NAME}}/run.py"]
