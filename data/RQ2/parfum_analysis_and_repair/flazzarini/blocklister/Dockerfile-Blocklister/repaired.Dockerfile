FROM python:3.7-alpine
MAINTAINER Frank Lazzarini <flazzarini@gmail.com>

ARG VERSION
EXPOSE 8000
ENV PKG=blocklister-${VERSION}-py3-none-any.whl

COPY dist/${PKG} /tmp/
RUN apk add --no-cache \
    python3-dev \
    openssl
RUN pip3 install --no-cache-dir -U pip
RUN pip3 install --no-cache-dir /tmp/${PKG}
RUN pip3 install --no-cache-dir gunicorn
RUN mkdir /lists/
RUN mkdir -p /etc/blocklister/
COPY dockerfiles/blocklister.conf /etc/blocklister/

CMD ["gunicorn", \
     "-b", "0.0.0.0", \
     "blocklister.main:app"]
