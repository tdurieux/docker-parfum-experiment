FROM squidfunk/mkdocs-material:2.6.2 AS build
COPY docs /docs/docs
COPY mkdocs.yml /docs
RUN mkdocs build --site-dir /site

FROM nginx:1.13.7-alpine
COPY --from=build /site /usr/share/nginx/html