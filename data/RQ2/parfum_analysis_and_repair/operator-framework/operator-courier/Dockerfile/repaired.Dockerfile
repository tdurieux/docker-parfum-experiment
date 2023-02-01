FROM python:3

ADD . /repo
WORKDIR /repo
RUN pip3 install --no-cache-dir .
RUN rm -rf /repo

CMD [ "operator-courier", "--help"]
