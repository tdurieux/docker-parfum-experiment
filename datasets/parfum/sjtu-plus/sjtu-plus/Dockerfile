FROM python:3.9-slim
WORKDIR /root

COPY ./requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt
COPY ./ __app/

CMD cd app && gunicorn -c gunicorn.conf.py SJTUPlus.wsgi:application -
