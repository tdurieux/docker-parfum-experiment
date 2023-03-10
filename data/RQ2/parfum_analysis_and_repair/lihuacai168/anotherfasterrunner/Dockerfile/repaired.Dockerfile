FROM python:3.6-alpine as Base

COPY requirements.txt .
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add --no-cache mariadb-connector-c-dev
RUN apk update && \
    apk add --no-cache python3-dev mariadb-dev build-base netcat-openbsd linux-headers pcre-dev && \
    pip install --no-cache-dir -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple && \
    apk del python3-dev mariadb-dev build-base linux-headers pcre-dev

#COPY requirements.txt .
#RUN pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

FROM python:3.6-alpine
ENV TZ=Asia/Shanghai
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk --no-cache add tzdata mariadb-connector-c-dev \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone && rm -rf /var/cache/apk/*

COPY --from=Base /usr/local/lib/python3.6/site-packages /usr/local/lib/python3.6/site-packages
WORKDIR /app
COPY . /app
RUN chmod +x /app/start.sh

ONBUILD RUN python manage.py collectstatic --settings=FasterRunner.settings.docker --no-input

