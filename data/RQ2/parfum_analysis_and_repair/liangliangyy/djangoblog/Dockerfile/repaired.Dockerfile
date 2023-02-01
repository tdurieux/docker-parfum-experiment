FROM python:3
ENV PYTHONUNBUFFERED 1
WORKDIR /code/djangoblog/
RUN apt-get install --no-install-recommends default-libmysqlclient-dev -y && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime && rm -rf /var/lib/apt/lists/*;
ADD requirements.txt requirements.txt
RUN pip install --no-cache-dir --upgrade pip && \
        pip install --no-cache-dir -Ur requirements.txt && \
        pip install --no-cache-dir gunicorn[gevent] && \
        pip cache purge

ADD . .
RUN chmod +x /code/djangoblog/bin/docker_start.sh
ENTRYPOINT ["/code/djangoblog/bin/docker_start.sh"]
