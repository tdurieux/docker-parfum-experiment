FROM python:3.10-alpine
LABEL Maintainer="Rajesh Rajendran<rjshrjndrn@gmail.com>"
LABEL Maintainer="KRAIEM Taha Yassine<tahayk2@gmail.com>"
RUN apk add --no-cache build-base tini
ARG envarg
ENV APP_NAME=crons \
    pg_minconn=2 \
    pg_maxconn=10 \
    ENTERPRISE_BUILD=${envarg} \
    ACTION=""

WORKDIR /work_tmp
COPY requirements-crons.txt /work_tmp/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /work_tmp/requirements.txt

WORKDIR /work
COPY . .
RUN mv env.default .env && mv entrypoint_crons.sh entrypoint.sh

ENTRYPOINT ["/sbin/tini", "--"]
CMD ./entrypoint.sh