FROM squidfunk/mkdocs-material:7.3.6

COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt