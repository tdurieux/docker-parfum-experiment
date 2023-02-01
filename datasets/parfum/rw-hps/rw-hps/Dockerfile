# https://hub.docker.com/_/openjdk?tab=tags&page=1&name=11.0.4

FROM openjdk:11.0.4-jre AS base
ENV TZ=Asia/Shanghai
WORKDIR /app
EXPOSE 5123

# build
FROM openjdk:11.0.4 AS build
WORKDIR /src
COPY . .
RUN chmod +x gradlew
#RUN ls -l
# 注意: gradlew 在 Windows 中的 Docker 下，
# 请保证为 Unix(LF) 行尾结束符，而不是 Windows(CR LF)，不然会报错: /usr/bin/env: ‘sh\r’: No such file or directory
RUN ./gradlew jar
RUN ls Server-All/build/libs -l
RUN echo "build success"

# final
FROM base AS final
WORKDIR /app
# 使用 Server-All/build/libs 即可
COPY --from=build /src/Server-All/build/libs .
COPY --from=build /src/docker/java-jar.sh .
COPY --from=build /src/docker/status.sh .
COPY --from=build /src/docker/connect.sh .
COPY --from=build /src/docker/restart.sh .
COPY --from=build /src/docker/supervisord.conf .
RUN chmod 777 status.sh
RUN chmod 777 connect.sh
RUN chmod 777 restart.sh

# 还需要有一个配置文件
COPY --from=build /src/docker/Config.json .
# Config.json 放在jar同级目录data/下
RUN mkdir data
RUN mv Config.json data/Config.json

RUN ls -l

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        supervisor \
    ; \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p \
    /var/log/supervisord \
    /var/run/supervisord \
;

RUN mv supervisord.conf /etc/supervisord.conf
RUN chmod 777 /var/run
RUN chmod 777 /var/log
RUN touch /var/run/supervisor.sock
RUN chmod 777 /var/run/supervisor.sock

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]