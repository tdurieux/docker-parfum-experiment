FROM node:lts

# Get build args
ARG NODE_ENV="production"

# Set environment variables
ENV NODE_ENV=${NODE_ENV}

# Install system packages
RUN apt-get update && apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;

# Configuring Nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Set working directory and copy project files
WORKDIR /usr/share/nginx/html

COPY ./packages/apps/build /usr/share/nginx/html

# Copying Nginx's site configuration
COPY ./nginx-default.conf /etc/nginx/sites-available/default

# Port to expose for other containers
EXPOSE 80

# Launching Nginx
CMD ["nginx"]
