FROM bloben/nginx:staging

ARG DOCKER_IMAGE_VERSION
ENV DOCKER_IMAGE_VERSION=$DOCKER_IMAGE_VERSION

COPY --from=bloben/admin:staging ./usr/app/admin ./usr/app/admin/
COPY --from=bloben/calendar:staging ./usr/app/calendar ./usr/app/calendar/
COPY --from=bloben/api:staging ./usr/app/api/ ./usr/app/api/
COPY --from=bloben/tasks:staging ./usr/app/tasks/ ./usr/app/tasks/

COPY nginx/init.sh /bin/
RUN chmod u+x /bin/init.sh

COPY /nginx/nginx.conf /etc/nginx

CMD /bin/init.sh