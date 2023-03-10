ARG version=latest
FROM python:$version

RUN pip install --no-cache-dir virtualenv

COPY prism/prism/nginx/cert.crt /usr/local/share/ca-certificates/cert.crt
RUN update-ca-certificates

WORKDIR /app
COPY . .

RUN make install
