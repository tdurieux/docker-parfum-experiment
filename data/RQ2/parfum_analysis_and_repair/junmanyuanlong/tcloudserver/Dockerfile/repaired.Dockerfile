FROM ccr.ccs.tencentyun.com/andromeda/tcloud_python:3.7
RUN pip install --no-cache-dir redis flask-caching
WORKDIR /tcloud
RUN mkdir logs
COPY . .
CMD ./docker_start.sh
