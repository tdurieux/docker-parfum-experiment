#
# Proxy to NYTLabels annotator, roundrobins between nytlabels-annotator instances
#

FROM gcr.io/mcback/nginx-base:latest

# Copy configuration
COPY nginx/include/nytlabels-annotator-webapp-proxy.conf /etc/nginx/include/

# Web server's port
EXPOSE 8080

# Run Nginx
CMD ["nginx"]
