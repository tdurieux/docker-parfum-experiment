FROM tiangolo/uwsgi-nginx-flask:python3.5

COPY ./app /app

ENV KEY "5ecur3pPYpyPYk3y"

RUN pip3 install --no-cache-dir PyCrypto

COPY entrypoint.sh /