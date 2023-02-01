FROM squidfunk/mkdocs-material:7.1.9

COPY requirements.txt /docs/requirements.txt
RUN pip install --no-cache-dir -U -r /docs/requirements.txt