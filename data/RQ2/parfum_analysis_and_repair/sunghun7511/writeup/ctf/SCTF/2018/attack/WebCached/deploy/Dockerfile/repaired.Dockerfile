FROM redis:2

RUN sed -i "s/http:\/\/deb.debian.org/http:\/\/ftp.daumkakao.com/g" /etc/apt/sources.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nginx-full && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;

ADD requirements.txt /tmp/r.txt
RUN pip install --no-cache-dir -r /tmp/r.txt && rm /tmp/r.txt
RUN ln -s /usr/local/bin/uwsgi /usr/bin/uwsgi

RUN mkdir -p /app
ADD src/ /app/

ADD uwsgi.ini /tmp
RUN rm /etc/nginx/sites-available/default
ADD nginx.conf /etc/nginx/sites-available/default

RUN rm -rf /var/lib/apt/lists/*
ADD run.sh /run.sh
RUN chmod 755 /*.sh

RUN chmod 555 /app/*


EXPOSE 34343
CMD ["/run.sh"]
