####################################################################
# Stage 1 : NODE_BUILD
#
# Use a docker image with NODE to build the deliverable
# Build everywhere
####################################################################

FROM node:12 as build
MAINTAINER Cedrick Lunven

# Get Sources
RUN apt update && \
  apt install --no-install-recommends -y git && \
	git clone https://github.com/spring-petclinic/spring-petclinic-angular.git /workspace && rm -rf /var/lib/apt/lists/*;

ARG NPM_REGISTRY=" https://registry.npmjs.org"

# Enforcing env var BACKEND_URL
RUN echo "export const environment = {production: false, REST_API_URL:  'http://petclinic-backend:9966/petclinic/api/'};" > /workspace/src/environments/environment.ts && \
	echo "registry = \"$NPM_REGISTRY\"" > /workspace/.npmrc && \
    cd /workspace/ && \
    npm install && \
    npm run build && npm cache clean --force;

####################################################################
# Stage 2 : RUNTIME
# Use the DIST folder to package an image with NGINX.
####################################################################

FROM nginx:1.19.4 AS runtime

COPY  --from=build /workspace/dist/ /usr/share/nginx/html/

RUN chmod a+rwx /var/cache/nginx /var/run /var/log/nginx                        && \
    sed -i.bak 's/listen\(.*\)80;/listen 8080;/' /etc/nginx/conf.d/default.conf && \
    sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf

EXPOSE 8080
USER nginx
HEALTHCHECK CMD [ "service", "nginx", "status" ]




