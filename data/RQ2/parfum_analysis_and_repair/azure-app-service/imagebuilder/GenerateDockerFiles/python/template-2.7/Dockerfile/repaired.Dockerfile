FROM BASE_IMAGE_NAME_PLACEHOLDER
LABEL maintainer="appsvc-images@microsoft.com"

# Web Site Home
ENV HOME_SITE "/home/site/wwwroot"
ENV APP_PATH "/home/site/wwwroot"

#Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        openssh-server \
        vim \
        curl \
        wget \
#        build-essential \
        tcptraceroute \
        net-tools \
        dnsutils \
        tcpdump \
        iproute2 \
        nano \
        cron \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir gunicorn \
    && pip install --no-cache-dir virtualenv \
    && pip install --no-cache-dir flask \
    && pip install --no-cache-dir scandir && rm -rf /var/lib/apt/lists/*;

COPY tcpping /usr/bin/tcpping
RUN chmod 755 /usr/bin/tcpping

WORKDIR ${HOME_SITE}

EXPOSE 8000
ENV PORT 8000
ENV SSH_PORT 2222

COPY common/run-diag.sh /run-diag.sh
RUN chmod +x /run-diag.sh

# setup SSH and acitvate virtual env on ssh into container
RUN mkdir -p /home/LogFiles \
     && echo "root:Docker!" | chpasswd \
     && echo "cd /home" >> /root/.bashrc

COPY sshd_config /etc/ssh/
RUN mkdir -p /opt/startup
COPY init_container.sh /opt/startup/init_container.sh

# gunicorn custom config
COPY gunicorn.conf.py /opt/startup
ENV PYTHON_USE_GUNICORN_CONFIG_FROM_PATH "/opt/startup/gunicorn.conf.py"

# setup appServiceAppLogs
RUN mkdir -p /opt/startup/app_logs
COPY common/app_logs/ /opt/startup/app_logs/
ENV PYTHONPATH "${PYTHONPATH}:/opt/startup/app_logs"

# setup default site
RUN mkdir /opt/defaultsite
COPY hostingstart.html /opt/defaultsite
COPY hostingstart_dep.html /opt/defaultsite
COPY application.py /opt/defaultsite

# configure startup
RUN chmod -R 777 /opt/startup
COPY entrypoint.py /usr/local/bin

ENTRYPOINT ["/opt/startup/init_container.sh"]
