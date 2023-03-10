FROM {{{dockerPrefix}}}portal-api:{{dockerTag}}{{buildAlpine}}

COPY . /tmp/portal-api

RUN rm -rf /var/portal-api/static \
    && cp -R /tmp/portal-api /var/portal-api/static \
    && date +%s > /var/portal-api/static/.dockerbuild \
    && date -u "+%Y-%m-%d %H:%M:%S" > /var/portal-api/static/build_date

CMD ["/bin/true"]