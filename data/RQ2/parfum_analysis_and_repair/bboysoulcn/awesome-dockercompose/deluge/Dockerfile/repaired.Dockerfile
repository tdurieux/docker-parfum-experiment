FROM ubuntu:16.04
COPY entrypoint.sh /
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    apt-get update && apt-get install --no-install-recommends deluge-web deluged -y && \
    chmod +x entrypoint.sh && mkdir /data && rm -rf /var/lib/apt/lists/*;
VOLUME /data
EXPOSE 80
ENTRYPOINT [ "./entrypoint.sh" ]