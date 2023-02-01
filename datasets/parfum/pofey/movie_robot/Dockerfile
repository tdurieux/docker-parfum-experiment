FROM python:3.8.9-slim as build
ENV TZ=Asia/Shanghai PGID=0 PUID=0 PYTHONPATH="${PYTHONPATH}:/dependencies"
RUN apt-get update \
	&& apt-get install -y gcc
ARG TARGETARCH
COPY requirements.txt /
WORKDIR /
RUN --mount=type=cache,target=/root/.cache,id=slim_pip_cache_$TARGETARCH python -m pip install --upgrade pip  \
	&& pip install --target=/dependencies -r requirements.txt \
	&& pip install --target=/dependencies Cython
COPY app /app
COPY yee /app/yee
WORKDIR /app
RUN --mount=type=cache,target=/app/build,id=cython_cache_$TARGETARCH  python setup_in_docker.py build_ext --inplace  \
	&& rm -rf setup_in_docker.py requirements.txt \
	&& pip uninstall -y Cython

FROM python:3.8.9-slim
LABEL title="影视剧机器人"
LABEL description="可以自动从豆瓣用户的想看、在看、看过列表中自动获取电影，并通过mteam查找种子，提交到qbittorrent中下载（依赖Emby管理影视原数据）"
LABEL authors="yipengfei"

VOLUME /data
EXPOSE 1329
ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive \
    LICENSE_KEY='' \
    PGID=0 \
    PUID=0 \
    PYTHONPATH="${PYTHONPATH}:/dependencies"
RUN apt-get update \
	&& apt-get install -y --no-install-recommends tzdata \
	&& ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime  \
	&& echo ${TZ} > /etc/timezone \
    && rm -rf /var/lib/apt/lists/*
COPY --from=build /dependencies /dependencies
COPY --from=build /app /app
WORKDIR /app
VOLUME /data
CMD python /app/start.py -w /data
