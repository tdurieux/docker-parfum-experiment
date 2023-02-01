FROM nginx:stable

RUN apt-get update && \
    apt-get install --no-install-recommends -q -y ruby && \
    rm -rf /var/lib/apt/lists/* && \
    gem install aws-sdk --no-document && \
    mkdir -p /etc/nginx/certs

ADD templates /templates
COPY render_template.rb /render_template.rb
COPY entrypoint /entrypoint

ENTRYPOINT ["/entrypoint"]
