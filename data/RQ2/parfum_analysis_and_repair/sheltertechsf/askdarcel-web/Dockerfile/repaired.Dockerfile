FROM nginx:stable

RUN apt-get update && apt-get -y --no-install-recommends install ruby && gem install tiller && rm -rf /var/lib/apt/lists/*;

COPY build /app/askdarcel
COPY version.json /app/askdarcel/_version.json
COPY tools/replace-environment-config.sh /app/askdarcel

RUN rm /etc/nginx/conf.d/*

ADD docker/tiller /etc/tiller

CMD ["tiller", "-v"]
ENTRYPOINT ["/app/askdarcel/replace-environment-config.sh", "/app/askdarcel/bundle.js"]
