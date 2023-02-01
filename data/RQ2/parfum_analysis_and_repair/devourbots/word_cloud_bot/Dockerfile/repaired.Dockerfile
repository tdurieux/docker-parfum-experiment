FROM rackspacedot/python37:latest
RUN apt-get update -y
RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends psmisc -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends bc -y && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /etc/localtime
RUN ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN cd /root \
    && git clone https://github.com/devourbots/word_cloud_bot.git
RUN sed -i '1c TOKEN = "这里输入机器人token"' /root/word_cloud_bot/config.py
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh \
    && pip3 install --no-cache-dir -r /root/word_cloud_bot/requirements.txt
ENTRYPOINT ["sh", "/root/entrypoint.sh"]