FROM objectiv/backend


ENV DEBIAN_FRONTEND=non-interactive


ENV APP=/services/version_checker/

USER root
# setup nginx proxy
RUN mkdir -p $APP && \
    apt -q update && \
    apt -qy upgrade && \
    apt install --no-install-recommends -qy nginx && \
    apt clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /services

COPY *.py  $APP
COPY requirements.txt $APP

RUN pip install --no-cache-dir -r version_checker/requirements.txt


COPY docker/gunicorn.conf.py /etc/
COPY docker/nginx.conf /etc/nginx/
COPY docker/entry_point.sh /services


CMD /services/entry_point.sh
ENTRYPOINT /services/entry_point.sh
