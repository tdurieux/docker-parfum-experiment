#ARGS
ARG NGINX_TAG=${NGINX_TAG}
ARG HOST_SERVER_NAME=${HOST_SERVER_NAME}

FROM nginx:${NGINX_TAG}

ARG GLPIPATH=${GLPIPATH}
# Environment variables
ENV GLPIPATH ${GLPIPATH}
ENV HOST_SERVER_NAME ${HOST_SERVER_NAME}

# Install modules
RUN apt-get update && apt-get install --no-install-recommends -y curl nano && rm -rf /var/lib/apt/lists/*;

WORKDIR $GLPIPATH
