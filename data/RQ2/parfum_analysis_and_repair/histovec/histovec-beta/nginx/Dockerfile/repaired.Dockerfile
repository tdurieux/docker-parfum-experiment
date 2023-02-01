#######################
# Step 1: Base target #
#######################
FROM nginx:1 as base
ARG app_name
ARG app_ver

WORKDIR /home/nginx

COPY run.sh run.sh
COPY nginx.template /etc/nginx/nginx.template

RUN  [ -f "run.sh" ] && chmod +x run.sh

################################
# Step 2: "development" target #
################################
FROM base as development
ARG app_name
ARG app_ver

COPY nginx-dev.template /etc/nginx/conf.d/default.template

CMD ["/home/nginx/run.sh"]
################################
# Step 2: "production" target #
################################