FROM nginx:1.17-alpine

# Remove default.conf
RUN rm /etc/nginx/conf.d/default.conf

# Copy config files
COPY conf.d /etc/nginx/conf.d
COPY prod.conf /etc/nginx/conf.d
