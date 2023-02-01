FROM cilerler/mkdocs AS build
MAINTAINER 	Viktor Farcic <viktor@farcic.com>
ADD . /docs
RUN pip install --no-cache-dir pygments && pip install --no-cache-dir pymdown-extensions
RUN mkdocs build --site-dir /site


FROM nginx:1.11-alpine
MAINTAINER 	Viktor Farcic <viktor@farcic.com>
COPY --from=build /site /usr/share/nginx/html