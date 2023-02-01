FROM squidfunk/mkdocs-material
RUN pip install --no-cache-dir mkdocs-markdownextradata-plugin
RUN apk add --no-cache -U git openssh

