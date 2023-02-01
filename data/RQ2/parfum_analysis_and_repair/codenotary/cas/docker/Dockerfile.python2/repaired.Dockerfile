FROM golang:1.16.6-buster as build
WORKDIR /src
COPY . .
RUN GOOS=linux GOARCH=amd64 make static

FROM python:2.7-slim-buster
RUN pip install --no-cache-dir pipenv
RUN pip install --no-cache-dir poetry
COPY --from=build /src/cas /bin/cas

ENTRYPOINT [ "/bin/cas" ]
