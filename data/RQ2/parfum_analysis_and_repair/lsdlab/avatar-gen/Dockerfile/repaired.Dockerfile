FROM python:3.6.5
MAINTAINER lsdvincent lsdvincent@gmail.com
COPY . /avatar-gen
WORKDIR /avatar-gen
RUN pip install --no-cache-dir -U pip setuptools
RUN pip install --no-cache-dir -r requirements.txt
CMD ["gunicorn", "app:app", "-c", "gunicorn.conf"]
CMD ["celery", "-A", "app.celery", "worker", "--loglevel=info", "--autoscale=4,2"]
