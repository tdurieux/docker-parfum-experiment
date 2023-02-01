FROM    nginx:stable
RUN apt-get update && apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN     mkdir -p /data/log/nginx
RUN     echo "alias ll='ls -al'" >> ~/.bashrc
ENV     TZ Asia/Seoul
