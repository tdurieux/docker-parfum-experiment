FROM squidfunk/mkdocs-material:8.3.0

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir mike && \
    pip install --no-cache-dir mkdocs-macros-plugin
