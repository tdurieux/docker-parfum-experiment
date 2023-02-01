FROM mono:6

WORKDIR /app
COPY CDP4WebServer/bin/Test/net472 /app
COPY LICENSE /app

RUN apt-get update -y && apt-get install --no-install-recommends -y nano netcat && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y



RUN mkdir /app/wait-for
COPY wait-for /app/wait-for
COPY entrypoint-test.sh /app

RUN mkdir /app/logs; exit 0
VOLUME /app/logs

RUN mkdir /app/storage; exit 0
VOLUME /app/storage

RUN mkdir /app/upload; exit 0
VOLUME /app/upload

#expose ports
EXPOSE 5000

CMD ["/bin/bash", "/app/entrypoint-test.sh"]