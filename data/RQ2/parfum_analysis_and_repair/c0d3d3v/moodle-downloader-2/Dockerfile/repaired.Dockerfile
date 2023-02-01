FROM python:3

ADD . /md

WORKDIR /md

RUN pip3 install --no-cache-dir .

ENTRYPOINT ["moodle-dl", "--path", "/files"]
