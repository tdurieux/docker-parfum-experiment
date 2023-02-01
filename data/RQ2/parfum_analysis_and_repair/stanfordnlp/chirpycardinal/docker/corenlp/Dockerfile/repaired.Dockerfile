FROM python:3.7-slim-buster

RUN apt-get clean all
RUN apt-get update -y && apt-get install --no-install-recommends -y nginx supervisor gcc g++ zip wget default-jre && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /usr/share/man/man1/


# update pip
RUN pip3 install --no-cache-dir pip --upgrade

# Setup flask application
RUN mkdir -p /deploy/app
COPY app/requirements.txt /deploy/app/requirements.txt
RUN pip install --no-cache-dir -r /deploy/app/requirements.txt

# Setup nginx
RUN rm /etc/nginx/sites-enabled/default
COPY config/flask.conf /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/flask.conf /etc/nginx/sites-enabled/flask.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

RUN ln -s /usr/local/bin/gunicorn /usr/bin/gunicorn

# Download CoreNLP
RUN cd /deploy && \
    wget https://nlp.stanford.edu/software/stanford-corenlp-full-2018-10-05.zip && \
    unzip stanford-corenlp-full-2018-10-05 && \
    export CORENLP_HOME=/deploy/stanford-corenlp-full-2018-10-05 && \
    rm stanford-corenlp-full-2018-10-05.zip && \
    cd ..

RUN cd /deploy/stanford-corenlp-full-2018-10-05 && wget https://nlp.stanford.edu/software/stanford-corenlp-caseless-2015-04-20-models.jar

# Setup supervisord
RUN mkdir -p /var/log/supervisor
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
#COPY config/gunicorn.conf /etc/supervisor/conf.d/gunicorn.conf

COPY app /deploy/app

EXPOSE 80

# Start processes
CMD ["/usr/bin/supervisord"]

