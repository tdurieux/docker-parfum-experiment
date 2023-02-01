FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y nginx openssl && rm -rf /var/lib/apt/lists/*;
CMD ["nginx", "-g", "daemon off;"]
