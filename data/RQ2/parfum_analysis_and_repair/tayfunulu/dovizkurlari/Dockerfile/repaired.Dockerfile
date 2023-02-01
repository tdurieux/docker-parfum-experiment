FROM python:slim


ADD requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

ADD . /app
WORKDIR app

CMD python /app/flask_doviz_server.py
