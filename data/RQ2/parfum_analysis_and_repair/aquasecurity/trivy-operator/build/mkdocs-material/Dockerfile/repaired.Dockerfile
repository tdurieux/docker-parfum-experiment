FROM squidfunk/mkdocs-material:8.2.7

RUN pip install --no-cache-dir mike
RUN pip install --no-cache-dir mkdocs-macros-plugin
