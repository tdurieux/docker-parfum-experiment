FROM python:3.7-slim AS build-image
LABEL maintainer="graphenex.project@protonmail.com"
ENV LC_ALL=C.UTF-8
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential gcc curl && rm -rf /var/lib/apt/lists/*;
RUN VERSION=$( curl -f --silent "https://api.github.com/repos/graphenex/grapheneX/releases/latest" | \
    grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') && \
    curl -f -LO https://github.com/grapheneX/grapheneX/archive/$VERSION.tar.gz && \
    tar -xzf $VERSION.tar.gz && \
    cd "grapheneX-$VERSION" && \
    pip install --no-cache-dir --user . && rm $VERSION.tar.gz

FROM python:3.7-slim AS runtime-image
COPY --from=build-image /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH
CMD ["/bin/sh", "-c", "grapheneX"]