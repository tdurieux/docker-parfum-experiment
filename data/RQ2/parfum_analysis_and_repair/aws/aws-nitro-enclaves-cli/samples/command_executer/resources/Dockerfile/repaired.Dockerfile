FROM ubuntu:latest
  COPY command-executer .
  RUN apt-get update && apt-get install --no-install-recommends -y \
      apt-utils && rm -rf /var/lib/apt/lists/*;
  CMD ./command-executer listen --port 5005
