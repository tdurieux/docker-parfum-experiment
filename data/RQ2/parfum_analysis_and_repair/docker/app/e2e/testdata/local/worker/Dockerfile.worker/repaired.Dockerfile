FROM nginx
ARG REPLACE_BY_BUILD_ARG
ARG STATIC_ARG
LABEL com.docker.labelled.arg=$REPLACE_BY_BUILD_ARG
LABEL com.docker.labelled.optional=$STATIC_ARG

COPY . .