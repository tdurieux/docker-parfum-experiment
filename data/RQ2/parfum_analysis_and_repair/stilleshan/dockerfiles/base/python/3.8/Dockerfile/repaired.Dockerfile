FROM python:3.8
LABEL maintainer="Stille <stille@ioiox.com>"

RUN apt-get update
RUN apt-get install --no-install-recommends -y zip vim && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir requests bs4 asyncio aiohttp lxml

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && apt-get install -y --no-install-recommends tzdata \
    && apt-get clean \
    && apt-get autoclean && rm -rf /var/lib/apt/lists/*;
