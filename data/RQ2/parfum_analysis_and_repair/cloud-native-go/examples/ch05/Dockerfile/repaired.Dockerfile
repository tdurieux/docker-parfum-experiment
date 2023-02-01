FROM ubuntu:18.04

RUN apt update && apt install --no-install-recommends --yes nginx && rm -rf /var/lib/apt/lists/*;

CMD ["nginx", "-g", "daemon off;"]
