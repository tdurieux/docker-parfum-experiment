FROM ${PROJECT_NAME}_test-base

COPY . /usr/src/app

RUN rm -rf /var/portal-api \\
    && cp -R /usr/src/app/test-config /var/portal-api

WORKDIR /usr/src/app

USER wicked

CMD ["bash", "-c", "/usr/src/app/test.sh"]

EXPOSE 3010