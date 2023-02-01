FROM python:3.6

ADD requirements.txt /app/
WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt

ADD . /app

EXPOSE 5000

CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
