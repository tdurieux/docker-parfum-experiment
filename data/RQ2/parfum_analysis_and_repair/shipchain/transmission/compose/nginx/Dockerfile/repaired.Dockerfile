FROM nginx

LABEL maintainer="Adam Hodges <ahodges@shipchain.io>"

RUN apt-get update && apt-get install --no-install-recommends -y python-pip jq && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir awscli

RUN mkdir -p /etc/nginx/certs
ADD ./nginx.conf /etc/nginx/conf.d/default.conf

COPY ./*.sh /
RUN chmod +x /*.sh
ENTRYPOINT ["/entrypoint.sh"]
