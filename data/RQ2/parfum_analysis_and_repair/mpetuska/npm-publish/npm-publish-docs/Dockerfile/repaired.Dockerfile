ARG mkdVersion
FROM squidfunk/mkdocs-material:$mkdVersion
RUN pip install --no-cache-dir mike
