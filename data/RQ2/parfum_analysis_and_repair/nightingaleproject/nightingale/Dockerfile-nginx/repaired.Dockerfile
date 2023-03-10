# Base image:
FROM nginx

# Install dependencies
RUN apt-get update -qq && apt-get -y --no-install-recommends install apache2-utils && rm -rf /var/lib/apt/lists/*;

# establish where Nginx should look for files
ENV RAILS_ROOT /var/www/nightingale

# Set our working directory inside the image
WORKDIR $RAILS_ROOT

# create log directory
RUN mkdir log

# copy over static assets
COPY --from=mitre/nightingale:latest /nightingale/public public/

# Copy Nginx config template
COPY config/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

# Use the "exec" form of CMD so Nginx shuts down gracefully on SIGTERM (i.e. `docker stop`)
CMD [ "nginx", "-g", "daemon off;" ]
