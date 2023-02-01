FROM ubuntu:20.04
LABEL maintainer="libreliu@foxmail.com"

WORKDIR /app
COPY ./ /app

ARG USE_PIP_MIRROR=no
ARG USE_APT_MIRROR=no
ARG USE_MYSQL=no

ENV DEBIAN_FRONTEND noninteractive

RUN (test ${USE_APT_MIRROR} = yes \
       && \
       (sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list) \
       || \
       (echo "APT mirror config untouched.");) \
    && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apt-get update \
    && apt-get install --no-install-recommends -y tzdata \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && apt-get install --no-install-recommends -y python3 python3-pip docker.io default-libmysqlclient-dev \
    && (test ${USE_PIP_MIRROR} = yes \
        && \
        (pip3 config set global.index-url https://mirrors.aliyun.com/pypi/simple/) \
        || \
        (echo "pip mirror config untouched.");) \
    && pip3 install --no-cache-dir -r requirements.txt \
    && ( test ${USE_MYSQL} = yes \
          && pip3 install --no-cache-dir mysqlclient==2.0.1 \
          || echo "Skipped MySQL setup.") && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT [ "celery", "-A", "judge", "worker", "-l", "INFO", "--concurrency=10" ]