FROM python:3.8.10-alpine

WORKDIR /usr/src/app
RUN pip install --no-cache-dir django gunicorn
COPY . .
ENV FLAG "we{testflag}"
ENV ADMIN_TOKEN 123
CMD ["gunicorn", "cache.wsgi", "-b", "0.0.0.0:80"]