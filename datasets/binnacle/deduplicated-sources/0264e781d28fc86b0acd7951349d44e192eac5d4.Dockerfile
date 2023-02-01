FROM python:2.7-alpine  
MAINTAINER Mosquito <me@mosquito.su>  
  
ENV ADDRESS=0.0.0.0  
ENV PORT=80  
ENV STORAGE=/usr/lib/pypi-server  
  
COPY ./ /usr/local/src  
  
WORKDIR /usr/local/src  
RUN set -ex \  
&& apk add --no-cache --virtual .build-deps \  
gcc \  
libffi-dev \  
openssl-dev \  
musl-dev \  
libxml2-dev \  
libxslt-dev \  
curl-dev \  
&& pip install \  
PyMySQL \  
&& python setup.py install --prefix=/usr/local \  
&& rm -rf /usr/local/src/{*,.*??} \  
&& find /usr/local -depth \  
\\( -type f -a -name '*.pyc' -o -name '*.pyo' \\) \  
-exec rm -rf '{}' \+ \  
&& runDeps="$( \  
scanelf --needed --nobanner --recursive /usr/local \  
| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \  
| sort -u \  
| xargs -r apk info --installed \  
| sort -u \  
)" \  
&& apk add --no-cache --virtual .pypi-server-rundeps \  
$runDeps \  
py-psycopg2 \  
&& apk del .build-deps  
  
VOLUME "/usr/lib/pypi-server"  
  
COPY docker-entrypoint.sh /entrypoint.sh  
  
EXPOSE 80  
ENTRYPOINT ["/entrypoint.sh"]  

