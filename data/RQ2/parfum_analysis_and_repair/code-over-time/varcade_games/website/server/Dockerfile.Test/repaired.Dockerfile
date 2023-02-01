FROM python:3.8-alpine
ENV PYTHONUNBUFFERED 1

RUN apk add --no-cache alpine-sdk
RUN apk add --no-cache bash
RUN apk add --no-cache vim
RUN apk add --no-cache redis
RUN apk add --no-cache mariadb-dev
RUN apk add --no-cache jpeg-dev
RUN apk add --no-cache libpng-dev
RUN apk add --no-cache libffi-dev

RUN mkdir /test_game_portal
RUN mkdir /test_game_portal/game_portal
WORKDIR /test_game_portal

ADD game_portal ./game_portal
ADD tests ./tests
ADD mypy.ini ./
ADD requirements.txt ./
ADD requirements_test.txt ./
ADD requirements_dev.txt ./

RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -r requirements_test.txt
RUN pip install --no-cache-dir -r requirements_dev.txt

CMD redis-server