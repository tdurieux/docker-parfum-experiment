FROM python:rc-alpine3.12

WORKDIR /usr/src/app
RUN apk update && apk add --no-cache python3-dev

RUN pip install --no-cache-dir --upgrade pip
COPY requirements.txt /usr/src/app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py /usr/src/app/
COPY static/ /usr/src/app/static/
COPY templates/ /usr/src/app/templates/
RUN adduser --disabled-password --gecos "" --no-create-home worker
RUN mkdir -p /var/app/data
RUN chown worker:nobody /var/app/data
USER worker:nobody
ENV DATA_DIR=/var/app/data

EXPOSE 6418

ENTRYPOINT ["python3"]

CMD ["-m", "gunicorn", "--chdir", "/usr/src/app", "-b", "0.0.0.0:6418", "-w", "3", "app:app"]
