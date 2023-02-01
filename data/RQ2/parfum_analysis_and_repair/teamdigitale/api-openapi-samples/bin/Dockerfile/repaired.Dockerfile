#
# Image to run various api tools based on
#  node and python.
#
FROM node:9
MAINTAINER robipolli@gmail.com

# Install python-yaml.
RUN apt update && apt install -y --no-install-recommends python-yaml && rm -rf /var/lib/apt/lists/*;

ADD Dockerfile
RUN npm install -g git+https://github.com/LucyBot-Inc/api-spec-converter.git --unsafe-perm=true --allow-root && npm cache clean --force;

ENTRYPOINT /usr/local/bin/api-spec-converter
CMD /usr/local/bin/api-spec-converter

