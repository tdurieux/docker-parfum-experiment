FROM python:3.6.9
COPY . /code/
EXPOSE 8001

RUN chmod u+x /code/django-config.sh

RUN echo $(tr -dc A-Za-z0-9 </dev/urandom | head -c 64) >> /etc/key.txt

WORKDIR /code/public
RUN pip install --no-cache-dir -r requirements.txt
