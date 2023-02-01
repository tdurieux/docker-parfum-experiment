FROM tiangolo/node-frontend:10 as build

WORKDIR /usr/src/app/frontend
COPY frontend .

## SETUP
RUN npm install && npm cache clean --force;

# SERVE
COPY tasking-manager.env ..
RUN npm run build

FROM nginx:stable-alpine
COPY --from=build /usr/src/app/frontend/build /usr/share/nginx/html
COPY --from=build /nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
