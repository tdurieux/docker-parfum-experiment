FROM python:3-onbuild
COPY . /usr/app/src
RUN pip install --no-cache-dir -r requirements.txt


CMD ["uwsgi", "config.ini"]
