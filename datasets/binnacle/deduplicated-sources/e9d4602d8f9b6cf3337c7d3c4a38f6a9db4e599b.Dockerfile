### Main image ###
FROM nginx:1.14.0-alpine

### Copy file ###
COPY ./dist /usr/share/nginx/html
COPY ./nginx /etc/nginx

### Expose ports ###
EXPOSE 80

LABEL source="git@github.com:kyma-project/console.git"
### Run app ###
CMD ["nginx", "-g", "daemon off;"]
