FROM python:2.7-jessie

RUN mkdir /opt/ngsildAdapter && \
    apt-get update -y && \
    apt install --no-install-recommends python-pip -y && \
    pip install --no-cache-dir flask && \
    pip install --no-cache-dir requests && \
    apt-get install --no-install-recommends python-dev -y && \
    pip install --no-cache-dir ConfigParser && \
    apt-get install --no-install-recommends software-properties-common -y && \
    curl -f -sL https://deb.nodesource.com/setup_11.x | bash - && \
    apt-get install --no-install-recommends nodejs -y && \
    node -v && \
    npm install axios && \
    npm install express && \
    npm install logops && \
    npm install shelljs && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt/ngsildAdapter

USER root

COPY ./ ./
RUN chmod +x transformer-config.sh && \
    chmod 777 transformer-config.sh

WORKDIR /opt/ngsildAdapter/module

ENTRYPOINT ["node","../main.js"]
EXPOSE 8888
