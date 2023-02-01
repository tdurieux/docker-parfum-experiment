FROM ubuntu:18.04

ADD ./docker_config/sources.list /etc/apt/
ADD ./docker_config/localtime /etc/localtime
ADD ./docker_config/init.sh /tmp/

COPY . /app/

RUN apt-get clean && apt-get update
RUN apt-get install --no-install-recommends -y vim python3 python3-pip nmap language-pack-zh-hans fontconfig git wget --fix-missing \
    && cd /app \
    && pip3 install --no-cache-dir -i https://pypi.douban.com/simple/ -r requirements.txt && rm -rf /var/lib/apt/lists/*;

RUN chmod +x /tmp/init.sh
RUN chmod -R +x /app/

RUN cd /tmp \
    && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt install --no-install-recommends -y ./google-chrome-stable_current_amd64.deb && rm -rf /var/lib/apt/lists/*;

CMD ["/tmp/init.sh"]
