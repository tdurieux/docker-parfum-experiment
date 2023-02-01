ARG SOURCE_IMAGE

# Copy assets from the main ETModel image. We need to use FROM to create an alias because COPY's
# --from won't expand a build arg.
FROM ${SOURCE_IMAGE} as source

# Base image
FROM nginx:latest

# Install dependencies
RUN apt-get update -qq && apt-get -y install apache2-utils

# Log to stdout and stderr.
RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

# Set our working directory inside the image
WORKDIR /html

# create log directory
RUN mkdir log

# copy over static assets
# COPY public public/

# Copy Nginx config template
COPY .docker/nginx/nginx.conf.template /etc/nginx/templates/default.conf.template

ARG SOURCE_IMAGE

# Copy the ETModel assets.
COPY --from=source /app/public /html/public

EXPOSE 80

# Use the "exec" form of CMD so Nginx shuts down gracefully on SIGTERM (i.e. `docker stop`)
CMD [ "nginx", "-g", "daemon off;" ]
