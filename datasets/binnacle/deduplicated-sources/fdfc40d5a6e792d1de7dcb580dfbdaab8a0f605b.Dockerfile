FROM alpine

# Get and install dependencies & packages
RUN sed -i 's/dl-cdn/dl-4/g' /etc/apk/repositories && \
    apk -U --no-cache add \
            build-base \
            curl \
            git \
            libxml2 \
            libxml2-dev \
            libxslt \
            libxslt-dev \
            openssl \
            openssl-dev \
            python \
            python-dev \
            py-future \
            py-pip \
            swig && \

# Setup user
    addgroup -g 2000 spiderfoot && \
    adduser -S -s /bin/ash -u 2000 -D -g 2000 spiderfoot && \

# Install spiderfoot 
#    git clone --depth=1 https://github.com/smicallef/spiderfoot -b v2.12.0-final /home/spiderfoot && \
    git clone --depth=1 https://github.com/smicallef/spiderfoot /home/spiderfoot && \
    cd /home/spiderfoot && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir wheel && \ 
    pip install --no-cache-dir -r requirements.txt && \ 
    chown -R spiderfoot:spiderfoot /home/spiderfoot && \
    sed -i "s#'__docroot': ''#'__docroot': '\/spiderfoot'#" /home/spiderfoot/sf.py && \
    sed -i 's#raise cherrypy.HTTPRedirect("\/")#raise cherrypy.HTTPRedirect("\/spiderfoot")#' /home/spiderfoot/sfwebui.py && \

# Clean up
    apk del --purge build-base \
                    git \
                    libxml2-dev \
                    libxslt-dev \
                    openssl-dev \
                    python-dev \
                    py-pip \
                    py-setuptools && \
    rm -rf /var/cache/apk/*

# Healthcheck
HEALTHCHECK --retries=10 CMD curl -s -XGET 'http://127.0.0.1:8080'

# Set user, workdir and start spiderfoot
USER spiderfoot:spiderfoot
WORKDIR /home/spiderfoot
CMD ["/usr/bin/python", "sf.py", "0.0.0.0:8080"]
