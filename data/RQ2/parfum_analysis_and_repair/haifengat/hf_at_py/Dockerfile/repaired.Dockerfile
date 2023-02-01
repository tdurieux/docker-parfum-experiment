FROM python:3.6.12-slim

# 换源到ali
RUN echo "deb http://mirrors.aliyun.com/debian/ buster main non-free contrib" > /etc/apt/sources.list; \
echo "deb-src http://mirrors.aliyun.com/debian/ buster main non-free contrib" >> /etc/apt/sources.list; \
echo "deb http://mirrors.aliyun.com/debian-security buster/updates main" >> /etc/apt/sources.list; \
echo "deb-src http://mirrors.aliyun.com/debian-security buster/updates main" >> /etc/apt/sources.list; \
echo "deb http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib" >> /etc/apt/sources.list; \
echo "deb-src http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib" >> /etc/apt/sources.list; \
echo "deb http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib" >> /etc/apt/sources.list; \
echo "deb-src http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib" >> /etc/apt/sources.list;

RUN set -ex; \
 apt-get update; \
# 安装talib依赖
 apt-get install --no-install-recommends -y python3-dev libssl-dev libffi-dev build-essential libxml2-dev libxslt1-dev; rm -rf /var/lib/apt/lists/*;

WORKDIR /
# ta-lib
ADD ta-lib-0.4.0-src.tar.gz .
RUN cd ta-lib/; \
 ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr; \
 make && make install; \
 cd .. && rm -f ta-lib-0.4.0-src.tar.gz && rm ta-lib -rf; \
 apt-get clean; \
# numpy 要先安装
 pip install --no-cache-dir --upgrade pip; \
 pip install --no-cache-dir numpy; \
# 支持将order写入pg
 pip install --no-cache-dir ta-lib pyyaml color_log psycopg2-binary redis sqlalchemy;

WORKDIR /hfpy
COPY hfpy ./hfpy/
COPY strategies/SMA* ./strategies/
COPY main.py .
# 添加默认策略
ENV strategy_names SMACross

ENTRYPOINT [ "python", "main.py" ]
