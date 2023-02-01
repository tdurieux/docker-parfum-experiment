FROM ubuntu

RUN  sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN apt-get clean && apt-get update && apt-get install --no-install-recommends -y curl \
    && curl -f -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
COPY src/ /app/
COPY flag /flag
RUN chmod 400 /flag && cp /bin/cat /catforflag && chmod u+s /catforflag && cd /app/ && npm install && npm cache clean --force;
USER nobody
ENTRYPOINT ["node", "/app/app.js"]