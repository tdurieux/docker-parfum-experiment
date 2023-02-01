FROM python:3.5

MAINTAINER TaeminKim <flatcoke89@gmail.com>

RUN apt-get update && apt-get install --no-install-recommends -y supervisor && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir uwsgi

RUN mkdir -p /deploy/flatcoke
RUN mkdir -p /deploy/log/uwsgi

ADD . /deploy/flatcoke/
WORKDIR /deploy/flatcoke

RUN pip install --no-cache-dir -r requirements.txt

COPY conf/uwsgi.ini /deploy/uwsgi.ini
COPY conf/supervisor.conf /etc/supervisor/conf.d/

CMD ["supervisord", "-n"]
