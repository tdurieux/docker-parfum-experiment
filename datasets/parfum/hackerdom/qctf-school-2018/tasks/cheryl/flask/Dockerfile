FROM python:3.5

ENV PYTHONUNBUFFERED 1

RUN mkdir -p /app
WORKDIR /app

COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app

RUN mkdir db
RUN python3 init_db.py

RUN chown -R www-data:www-data db
RUN chmod -R a+rw db

EXPOSE 80

CMD ["./run-with-gunicorn.sh"]
