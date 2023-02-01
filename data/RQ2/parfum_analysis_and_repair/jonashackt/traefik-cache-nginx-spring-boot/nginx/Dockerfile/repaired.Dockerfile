# we need our own Dockerfile here, because we want Nginx to log into the Docker log system
# see https://stackoverflow.com/a/42369571/4964553
FROM nginx:alpine

# forward request and error logs to docker log collector