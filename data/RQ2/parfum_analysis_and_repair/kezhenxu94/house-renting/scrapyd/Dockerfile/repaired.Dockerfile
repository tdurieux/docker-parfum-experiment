FROM python:3

VOLUME /etc/scrapyd/ /var/lib/scrapyd/

COPY ./scrapyd.conf /etc/scrapyd/

RUN pip install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple scrapyd

ENTRYPOINT ["scrapyd"]
