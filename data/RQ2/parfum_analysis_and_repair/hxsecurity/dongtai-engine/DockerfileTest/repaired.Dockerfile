FROM python:3.7.7
ARG VERSION
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV TZ=Asia/Shanghai

RUN curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add - \
    && apt-key fingerprint ABF5BD827BD9BF62 \
    && apt-get update -y \
    && apt install --no-install-recommends -y libc6-dev vim fonts-wqy-microhei && rm -rf /var/lib/apt/lists/*;

COPY requirements-test.txt /opt/dongtai/engine/requirements.txt
RUN pip3 install --no-cache-dir --upgrade pip && pip3 install --no-cache-dir -r /opt/dongtai/engine/requirements.txt

COPY . /opt/dongtai/engine
WORKDIR /opt/dongtai/engine

ENTRYPOINT ["/bin/bash","/opt/dongtai/engine/docker/entrypoint.sh"]
