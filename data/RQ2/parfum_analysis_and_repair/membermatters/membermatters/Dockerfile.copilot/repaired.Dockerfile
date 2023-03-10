# Specify our base image
FROM alpine:3.13
LABEL maintainer="Jaimyn Mayer (github@jaimyn.com.au)"
LABEL description="Base Dockerfile for the MemberMatters software."

# Volumes don't really make sense when deploying to ECS
# VOLUME /usr/src/data/
# VOLUME /usr/src/logs/

# Copy over the nginx config file
ADD memberportal/requirements.txt /usr/src/app/memberportal/requirements.txt
ADD frontend/package.json /usr/src/app/frontend/package.json
ADD frontend/package-lock.json /usr/src/app/frontend/package-lock.json
ADD docker/nginx.conf /etc/nginx/nginx.conf
WORKDIR /usr/src/app/

# Install nginx and other build dependencies
RUN apk update \
    && apk add --no-cache make gcc g++ musl-dev libffi-dev openssl-dev zlib-dev jpeg-dev bash libpng-dev openrc cargo nginx vips-dev python2 python3 python3-dev py3-pip nodejs npm mariadb-dev mariadb-client \
    # Create some base folders for everything
    && mkdir /usr/src/logs && mkdir /usr/src/data \
    # Install node deps
    && cd /usr/src/app/frontend/ \
    && npm ci \
    # Install python deps
    && cd /usr/src/app/memberportal/ \
    $$ pip3 install --no-cache-dir pillow \
    && pip3 install --no-cache-dir -r requirements.txt && rm -rf /usr/src/logs

# Copy over app code
ADD memberportal /usr/src/app/memberportal
ADD frontend /usr/src/app/frontend
ADD docker /usr/src/app/docker

# Build out the code:
RUN cd /usr/src/app/memberportal/ \
    && python3 manage.py collectstatic --noinput \
    # Build our frontend
    && cd /usr/src/app/frontend/ \
    && npm run build \
    # Remove node_modules and our .npmrc
    && rm -rf .npmrc node_modules/ \
    # Remove build deps we don't need anymore
    && apk del --no-cache --purge make gcc g++ musl-dev libffi-dev openssl-dev zlib-dev jpeg-dev bash libpng-dev cargo vips-dev python2 python3-dev npm \
    && rm -rf /var/cache/apk/*

# Expose the port and run the app
EXPOSE 8000
CMD ["sh", "/usr/src/app/docker/container_start_no_setup.sh"]
