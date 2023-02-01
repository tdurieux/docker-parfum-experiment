FROM python:3.6

RUN pip install --no-cache-dir cppcloud-web
COPY docker/docker-entrypoint-py.sh docker-entrypoint-py.sh
# COPY web_py/src/cppcloud_web.py /usr/local/lib/python3.6/site-packages/cppcloud_web/cppcloud_web.py

CMD sh docker-entrypoint-py.sh