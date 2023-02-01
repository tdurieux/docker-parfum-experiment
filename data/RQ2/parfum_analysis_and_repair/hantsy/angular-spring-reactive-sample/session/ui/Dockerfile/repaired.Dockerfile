# Set nginx base image
FROM nginx:alpine-perl

LABEL maintainer="Hantsy Bai"

EXPOSE 80
## Remove default Nginx website