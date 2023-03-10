#########################################
# Python3 flask server and some other libs

FROM pdonorio/py3api
MAINTAINER "Paolo D'Onorio De Meo <p.donoriodemeo@gmail.com>"

RUN apt-get update && apt-get install --no-install-recommends -y -q \
    # Zoomify extra python libs
    python2.7-minimal python-pil \
    # Images conversion
    imagemagick \
    # # Multithread apis (like uber)
    # gunicorn \
    && apt-get clean autoclean && apt-get autoremove -y && \
    rm -rf /var/lib/cache /var/lib/log && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip \

    Pillow \

    git+git://github.com/mattupstate/flask-security \

    flask-admin \

    timestring openpyxl xlrd pandas \



    rethinkdb \

    git+https://github.com/pdonorio/commentjson@master \

    peewee gspread oauth2client

# #################################
# # RETHINKDB python latest driver?
# git clone https://github.com/rethinkdb/rethinkdb.git
# cd rethinkdb/
# git checkout next
# ./configure --allow-fetch
# make --directory ./drivers/python
# cd drivers/python/
# python3 setup.py install

# rethinkdb-dump -c rdb -f /code/backup/latest.tar.gz

# #################################
# # Development user
# ENV NEWUSER developer
# RUN adduser --disabled-password $NEWUSER

# # ENV HOMEDIR /home/$NEWUSER
# # RUN mkdir -p $HOMEDIR
# # RUN chown -R $NEWUSER $HOMEDIR

ENV UWSGI_LOGS /var/log/uwsgi
ENV UWSGI_RUN /var/run/uwsgi
RUN mkdir -p $UWSGI_LOGS
RUN mkdir -p $UWSGI_RUN
# RUN chown -R $NEWUSER:$NEWUSER $UWSGI_LOGS
# USER $NEWUSER

# USER root
RUN chown -R www-data:www-data $UWSGI_LOGS $UWSGI_RUN

ADD init.sh /usr/sbin/init
# ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/usr/sbin/init"]
# CMD ["sleep", "infinity"]

