#
# Munin HTTP server
#

FROM gcr.io/mcback/nginx-base:latest

# Install Munin's static web files, e.g. CSS stylesheets
RUN apt-get -y --no-install-recommends install munin && rm -rf /var/lib/apt/lists/*;

# Copy configuration
COPY nginx/include/munin-httpd.conf /etc/nginx/include/

# Volume for generated HTML (shared with munin-cron)
VOLUME /var/cache/munin/www/

# Web server's port
EXPOSE 4948

# No USER because Nginx runs as "nobody" by default

# Run Nginx
CMD ["nginx"]
