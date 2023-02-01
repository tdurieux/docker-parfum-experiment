FROM handsonsecurity/seed-ubuntu:small
ARG DEBIAN_FRONTEND=noninteractive

# Instrall the nginx server
RUN apt-get update && apt-get -y --no-install-recommends install nginx && rm -rf /var/lib/apt/lists/*;

CMD service nginx start && tail -f /dev/null

