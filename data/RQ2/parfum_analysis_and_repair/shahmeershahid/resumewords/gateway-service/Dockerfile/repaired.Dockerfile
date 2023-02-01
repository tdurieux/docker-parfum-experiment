FROM python:3-onbuild
COPY . /usr/src/app
RUN pip install --no-cache-dir -r requirements.txt
CMD ["uwsgi", "config.ini"]