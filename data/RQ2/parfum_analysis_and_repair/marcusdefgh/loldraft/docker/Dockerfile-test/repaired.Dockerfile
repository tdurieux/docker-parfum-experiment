FROM python:3.6

ADD requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

ADD . /app/
WORKDIR /app/LOLtools.scrapy

CMD ['/bin/bash']