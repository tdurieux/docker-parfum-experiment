FROM node:alpine as build
WORKDIR /app
COPY . /app
ENV PATH /app/node_modules/.bin:$PATH
RUN yarn && yarn cache clean;
RUN yarn build && yarn cache clean;
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
# --------- only for those using react router ----------
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]