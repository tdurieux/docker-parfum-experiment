FROM python:3.6.15-alpine3.15  AS builder
RUN  sed -i s/#http/http/g  /etc/apk/repositories && \
	 apk add --no-cache wget unzip bash gcc g++ make python3-dev openssl-dev libffi-dev

RUN  wget -O master.zip  --no-check-certificate  \
	 https://github.com/monero-ecosystem/monero-python/archive/refs/heads/master.zip  && \
	 unzip master.zip  && \
	 mv monero-python-master /app  && \
	 cd /app  && \
	 python3 -m venv .venv  && \
	 echo c291cmNlIC52ZW52L2Jpbi9hY3RpdmF0ZQpwaXAzIGluc3RhbGwgLXIgcmVxdWlyZW1lbnRzLnR4dAo=  \
	      | base64 -d >  py-venv.sh  && \
	 bash py-venv.sh
##################################################################
FROM python:3.6.15-alpine3.15  AS  Release
COPY --from=builder  /app  /app
ADD  ./xmseed.py  /app/xmseed.py

WORKDIR  /app
RUN  apk add --no-cache bash  && \
	 echo IyEvYmluL2Jhc2gKICAgIApzb3VyY2UgLnZlbnYvYmluL2FjdGl2YXRlCnB5dGhvbjMgeG1zZWVkLnB5  \
	    | base64 -d > run.sh  && \
	 chmod +x  run.sh

RUN  find / -depth -name '__pycache__' -type d -exec rm -rf {} \;  && \
	 rm  /app/tests -rf  && \
	 rm  /app/.venv/share/python-wheels/* -rf  && \
	 rm  /app/.venv/lib/python3.6/site-packages/pip*  -rf && \
	 rm  /app/.venv/lib/python3.6/site-packages/setuptools* -rf && \
	 rm  /usr/local/include/python3.6  -rf  && \
 	 rm  /usr/share/zoneinfo  /etc/ssl  /tmp -rf  && \
 	 cd  /usr/local/lib/python3.6/site-packages  && \
	 rm  pip  setuptools  pkg_resources  -rf
##################################################################

FROM scratch
COPY --from=Release   .  .
WORKDIR  /app
CMD ["bash", "run.sh"]
##################################################################
# Usage:  docker run --rm -it xmseed

# docker run --name xmseed -itd hongwenjun/xmseed sh
# docker exec -it xmseed  bash run.sh