FROM python:3-alpine

ADD requirements.txt /tmp/requirements.txt

RUN pip install --no-cache-dir -r /tmp/requirements.txt

ADD app.py /var/server/app.py

CMD python /var/server/app.py
