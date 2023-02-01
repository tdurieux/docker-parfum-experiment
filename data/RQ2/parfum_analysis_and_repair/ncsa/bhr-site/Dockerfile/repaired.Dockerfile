FROM python:3.8
ENV PYTHONUNBUFFERED 1
RUN mkdir /app
WORKDIR /app
ADD requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt
ADD . /app/
RUN python manage.py collectstatic --noinput
ADD CHECKS /app/CHECKS
