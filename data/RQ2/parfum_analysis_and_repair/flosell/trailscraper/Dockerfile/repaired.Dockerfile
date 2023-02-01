FROM python:3.7-alpine as base
FROM base as builder

RUN apk add --no-cache build-base

COPY . /src
WORKDIR /src

RUN mkdir /install
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt
RUN python3 setup.py sdist bdist_wheel
RUN pip install --no-cache-dir --prefix=/install dist/trailscraper*.tar.gz


FROM base

COPY --from=builder /install /usr/local

ENTRYPOINT ["/usr/local/bin/trailscraper"]
