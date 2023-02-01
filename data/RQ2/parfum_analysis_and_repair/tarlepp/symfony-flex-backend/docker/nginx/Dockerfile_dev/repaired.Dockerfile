FROM nginx:latest

ADD nginx-dev.conf /etc/nginx/conf.d/default.conf
ADD php-upstream.conf /etc/nginx/conf.d/upstream.conf

# https://cloud.google.com/monitoring/agent/plugins/nginx
RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN cd /etc/nginx/conf.d/ \
    && curl -f -O https://raw.githubusercontent.com/Stackdriver/stackdriver-agent-service-configs/master/etc/nginx/conf.d/status.conf \
    && rm -rf /var/lib/apt/lists/*
