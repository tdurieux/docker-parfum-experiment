ARG version=latest

# Test Image
FROM moorara/site-service:$version
USER root
ENV NODE_ENV test
RUN npm install && npm cache clean --force;
