FROM lscr.io/linuxserver/ombi
COPY update-hosts.sh /update-hosts.sh
COPY run.sh /run.sh
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && apt install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT [ "sh", "/run.sh" ]