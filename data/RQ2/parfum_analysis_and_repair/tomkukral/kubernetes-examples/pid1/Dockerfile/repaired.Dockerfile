FROM nginx

RUN apt-get update && apt-get install --no-install-recommends -y procps && rm -rf /var/lib/apt/lists/*

COPY start.sh /start.sh
#CMD "/start.sh"
CMD ["/start.sh"]
