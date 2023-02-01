FROM thinkcube/mkdocs
RUN pip install --no-cache-dir mkdocs-material pygments >=2.2 pymdown-extensions >=2.0
RUN mkdir -p /tmp/mkdocs
WORKDIR /tmp/mkdocs
