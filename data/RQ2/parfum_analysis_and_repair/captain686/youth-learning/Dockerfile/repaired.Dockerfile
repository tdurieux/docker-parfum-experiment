FROM captain686/chrome-selenium

ENV LANG c.utf8

COPY dxx/ home/dxx

WORKDIR /home/dxx

RUN chmod 777 start.sh \
    && mkdir -p /usr/share/fonts/chinese/ \
    && chmod 777 qbot/go-cqhttp


COPY dxx/tff/MI_LanTing_Regular.ttf /usr/share/fonts/chinese/

RUN apt-get update \
    && apt-get install --no-install-recommends -y cron \
    && fc-cache /usr/share/fonts/chinese/ \
    && service cron start && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip3 install --no-cache-dir -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

RUN crontab crontab \
    && rm -rf crontab \
    && rm requirements.txt

CMD ["bash","start.sh"]
