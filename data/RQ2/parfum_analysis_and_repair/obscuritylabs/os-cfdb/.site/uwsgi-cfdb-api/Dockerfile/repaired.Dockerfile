FROM python:3

ENV C_FORCE_ROOT true

ENV PROD_TYPE production
ENV HOST 0.0.0.0
ENV PORT 5000
ENV DEBUG false
ENV MONGODB_URL mongodb://mongo:27017
ENV REDIS_RATELIMIT_STORAGE_URL redis://redis:6379/0
ENV CACHE_REDIS_URL redis://redis:6379/0

RUN pip install --no-cache-dir flask && \
    pip install --no-cache-dir uwsgi && \
    pip install --no-cache-dir pymongo && \
    pip install --no-cache-dir psutil && \
    pip install --no-cache-dir flask_limiter && \
    pip install --no-cache-dir redis && \
    pip install --no-cache-dir Flask-Caching && \
    pip install --no-cache-dir flask_apscheduler

#RUN git clone https://github.com/obscuritylabs/OS-CFDB.git /root/OS-CFDB/

#RUN python '/root/cfdb-api/init_mongo.py' /root/OS-CFDB/

ENTRYPOINT ["uwsgi", "--ini", "/root/cfdb-api/uwsgi.ini"]
