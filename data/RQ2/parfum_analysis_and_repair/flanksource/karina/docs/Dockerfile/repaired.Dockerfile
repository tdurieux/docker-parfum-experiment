FROM squidfunk/mkdocs-material:6.2.8
RUN apk add --no-cache --update nodejs npm nghttp2-dev unzip
RUN npm install netlify-cli && npm cache clean --force;
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
