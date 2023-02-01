FROM tiangolo/uwsgi-nginx-flask:python3.9

RUN pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
COPY ./requirements-dev.txt /tmp/
RUN pip3 install --no-cache-dir -r /tmp/requirements-dev.txt
COPY ./app /app
RUN chown -R nobody:nginx /app && chmod -R ugo-w /app

ENV STATIC_PATH /app/app/static