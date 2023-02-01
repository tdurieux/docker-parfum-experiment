FROM cilerler/mkdocs AS build
RUN pip install --no-cache-dir pygments && pip install --no-cache-dir pymdown-extensions
ADD . /docs
RUN mkdocs build --site-dir /site

FROM nginx:alpine
COPY --from=build /site /usr/share/nginx/html