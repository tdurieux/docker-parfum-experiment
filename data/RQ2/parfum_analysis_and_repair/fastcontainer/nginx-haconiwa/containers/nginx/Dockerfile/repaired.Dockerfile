FROM haconiwa-container:base

ENV IMAGE_NAME nginx
RUN apt update -yy && \
    apt install --no-install-recommends -yy nginx && rm -rf /var/lib/apt/lists/*;

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
