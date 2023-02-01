---
title: "Dockerfile"
draft: false
---
```bash
FROM httpd:2.4

LABEL maintainer="ivmachiavelli"

RUN apt-get update && apt-get install -y --no-install-recommends fortunes && rm -rf /var/lib/apt/lists/*;

COPY script.sh ~/home

EXPOSE 80
```

Building the image
```bash
docker image build --tag web-server:1.0 .
```
