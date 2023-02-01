FROM ubuntu:14.04
MAINTAINER Kate Heddleston <kate@makemeup.co>

RUN DEBIAN_FRONTEND=noninteractive apt-get update --fix-missing && apt-get install --no-install-recommends -y build-essential git python python-dev python-setuptools nginx supervisor bcrypt libssl-dev libffi-dev libpq-dev vim rsyslog wget libjpeg-dev libpng-dev && rm -rf /var/lib/apt/lists/*;
RUN easy_install pip

# stop supervisor service as we'll run it manually
RUN service supervisor stop
RUN mkdir /var/log/gunicorn && mkdir /var/log/deploys
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/default

RUN mkdir /opt/code

# Add logging conf file
RUN wget -O ./remote_syslog.tar.gz https://github.com/papertrail/remote_syslog2/releases/download/v0.17/remote_syslog_linux_amd64.tar.gz && tar xzf ./remote_syslog.tar.gz && cp ./remote_syslog/remote_syslog /usr/bin/remote_syslog && rm ./remote_syslog.tar.gz && rm -rf ./remote_syslog/

# Add requirements and install
COPY ./files/requirements.txt /opt/code/
RUN pip install --no-cache-dir -r /opt/code/requirements.txt

WORKDIR /opt/code

# expose port(s)
EXPOSE 80 81

CMD supervisord -c /etc/supervisor/conf.d/supervisord.conf
