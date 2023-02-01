# Use an existing user image as a base
FROM alpine

# Download and install a dependency
RUN apk add --no-cache --update redis
RUN apk add --no-cache --update gcc

# Tell the image what to do when it starts as a container
CMD [ "redis-server" ]
