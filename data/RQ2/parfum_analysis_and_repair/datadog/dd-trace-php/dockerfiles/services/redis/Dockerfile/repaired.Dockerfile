FROM circleci/redis:5.0-alpine

RUN apk add --no-cache gettext

ADD app_start.sh /app_start.sh
ADD conf_template.conf /conf_template.conf
ADD conf_template_cluster.conf /conf_template_cluster.conf

CMD /app_start.sh
