FROM poocongonlen/poconguserbot:buster

RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    npm i -g npm && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

RUN git clone -b main https://github.com/poocong/PocongUserbot /home/poconguserbot/ \
    && chmod 777 /home/poconguserbot \
    && mkdir /home/poconguserbot/bin/

WORKDIR /home/poconguserbot/

CMD [ "bash", "start" ]
