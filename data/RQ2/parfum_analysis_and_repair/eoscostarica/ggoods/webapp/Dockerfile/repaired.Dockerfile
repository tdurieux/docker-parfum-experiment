FROM node:12.16.2-alpine  as build-stage

ARG port
ARG react_app_title
ARG react_app_version
ARG react_app_logo
ARG react_app_footer_links
ARG react_app_ual_app_name
ARG react_app_ual_api_protocol
ARG react_app_ual_api_host
ARG react_app_ual_api_port
ARG react_app_ual_chain_id
ARG react_app_hasura_url
ARG react_app_map_api_key
ARG react_app_ipfs_url
ARG react_app_block_explorer
ARG react_app_block_explorer_url
ARG react_app_paypal_client_id
ARG react_app_oauth_google_client_id
ARG react_app_map_base_url

ENV WORK_DIR /usr/src/app
ENV PATH $WORK_DIR/node_modules/.bin:$PATH
ENV NODE_ENV production
ENV NODE_PATH ./src
ENV PORT $port
ENV REACT_APP_TITLE $react_app_title
ENV REACT_APP_VERSION $react_app_version
ENV REACT_APP_LOGO $react_app_logo
ENV REACT_APP_FOOTER_LINKS $react_app_footer_links
ENV REACT_APP_UAL_APP_NAME $react_app_ual_app_name
ENV REACT_APP_UAL_API_PROTOCOL $react_app_ual_api_protocol
ENV REACT_APP_UAL_API_HOST $react_app_ual_api_host
ENV REACT_APP_UAL_API_PORT $react_app_ual_api_port
ENV REACT_APP_UAL_CHAIN_ID $react_app_ual_chain_id
ENV REACT_APP_HASURA_URL $react_app_hasura_url
ENV REACT_APP_MAP_API_KEY $react_app_map_api_key
ENV REACT_APP_IPFS_URL $react_app_ipfs_url
ENV REACT_APP_BLOCK_EXPLORER $react_app_block_explorer
ENV REACT_APP_BLOCK_EXPLORER_URL $react_app_block_explorer_url
ENV REACT_APP_PAYPAL_CLIENT_ID $react_app_paypal_client_id
ENV REACT_APP_MAP_BASE_URL $react_app_map_base_url
ENV REACT_APP_OAUTH_GOOGLE_CLIENT_ID $react_app_oauth_google_client_id

RUN mkdir -p $WORK_DIR
WORKDIR $WORK_DIR

COPY package.json $WORK_DIR/package.json
COPY yarn.lock $WORK_DIR/yarn.lock

RUN yarn install && yarn cache clean;

COPY ./ $WORK_DIR

RUN yarn build

FROM nginx:1.17.10-alpine as run-stage

COPY --from=build-stage /usr/src/app/build /usr/share/nginx/html
COPY --from=build-stage /usr/src/app/compression.conf /etc/nginx/conf.d/compression.conf
COPY --from=build-stage /usr/src/app/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
