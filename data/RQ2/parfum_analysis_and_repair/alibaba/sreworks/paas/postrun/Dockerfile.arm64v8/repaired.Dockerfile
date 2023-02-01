FROM reg.docker.alibaba-inc.com/abm-arm64v8/python27
COPY . /app
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update \
    && apk add --no-cache gettext libintl mysql-client bash tzdata \
    && pip install --no-cache-dir -r /app/requirements.txt
WORKDIR /app
ENTRYPOINT ["/app/entrypoint.sh"]
