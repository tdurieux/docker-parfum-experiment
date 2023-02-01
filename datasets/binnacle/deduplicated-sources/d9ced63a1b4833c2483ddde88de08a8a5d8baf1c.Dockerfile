# Copyright IBM Corp, All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#
FROM node:8.9 as build_js
MAINTAINER haitao yue "hightall@me.com"
RUN cd /tmp && git clone https://github.com/hyperledger/cello.git
RUN cp -r /tmp/cello/src/operator-dashboard/static /var/www
RUN cd /var/www/dashboard && npm install && npm run build

FROM hyperledger/cello-baseimage:x86_64-latest

COPY --from=build_js /var/www/dist /app/static/dist
COPY --from=build_js /tmp/cello/src/operator-dashboard/celery.conf /etc/supervisor/conf.d/
CMD /etc/init.d/supervisor start && bash /app/init_client_secrets.sh && if [ "$DEBUG" = "True" ]; then python dashboard.py ; else gunicorn -w 1 --worker-class eventlet -b 0.0.0.0:8080 dashboard:app ;fi
