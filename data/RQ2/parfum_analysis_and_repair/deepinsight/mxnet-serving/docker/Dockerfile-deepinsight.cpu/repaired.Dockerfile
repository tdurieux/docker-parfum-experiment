FROM awsdeeplearningteam/mms_cpu:latest

RUN pip install --no-cache-dir scipy sklearn \
    && rm -f /etc/nginx/sites-enabled/default

LABEL maintainer="tyrion.huang@infinivision.io"
