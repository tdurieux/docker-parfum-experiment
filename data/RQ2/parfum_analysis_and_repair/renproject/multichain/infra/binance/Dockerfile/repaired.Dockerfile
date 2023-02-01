FROM ubuntu:xenial

RUN apt-get update --fix-missing
RUN apt-get install --no-install-recommends --yes curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install --no-install-recommends --yes nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g ganache-cli && npm cache clean --force;

COPY run.sh /root/run.sh
RUN chmod +x /root/run.sh

EXPOSE 8575

ENTRYPOINT ["./root/run.sh"]
