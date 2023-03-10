FROM golang:1.16.3 AS goose
RUN go get -u github.com/pressly/goose/cmd/goose

FROM python:3.7
COPY --from=goose /go/bin/goose /usr/local/bin/

ADD services/__init__.py /root/services/__init__.py
ADD services/utils /root/services/utils
ADD services/migration_service /root/services/migration_service
ADD setup.py setup.cfg /root/
WORKDIR /root
RUN pip install --no-cache-dir --editable .
CMD migration_service