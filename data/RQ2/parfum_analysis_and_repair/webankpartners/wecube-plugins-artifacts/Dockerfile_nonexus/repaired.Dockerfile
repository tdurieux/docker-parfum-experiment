FROM python:3.7-slim
LABEL maintainer = "Webank CTB Team"
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list
RUN sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list
ADD artifacts-corepy/requirements.txt /tmp/requirements.txt
ADD artifacts-corepy/dist/* /tmp/
RUN mkdir -p /etc/artifacts_corepy/
RUN mkdir -p /var/log/artifacts_corepy/
ADD artifacts-corepy/etc/* /etc/artifacts_corepy/
# Install && Clean up
RUN apt update && apt-get -y --no-install-recommends install gcc swig libssl-dev python3-dev && \
    pip3 install --no-cache-dir -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com -r /tmp/requirements.txt && \
    pip3 install --no-cache-dir /tmp/*.whl && \
    rm -rf /root/.cache && apt autoclean && \
    rm -rf /tmp/* /var/lib/apt/* /var/cache/* && \
    apt purge -y `cat /var/log/apt/history.log|grep 'Install: '|tail -1| sed 's/Install://'| sed 's/\ /\n/g' | sed '/(/d' | sed '/)/d' | sed ':l;N;s/\n/ /;b l'` && rm -rf /var/lib/apt/lists/*;
ADD build/start_all.sh /scripts/start_all.sh
RUN chmod +x /scripts/start_all.sh
CMD ["/bin/sh","-c","/scripts/start_all.sh"]