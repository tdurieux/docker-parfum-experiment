FROM registry.access.redhat.com/ubi8/nodejs-14-minimal AS frontend-builder

ENV NPM_CACHE_LOCATION=$HOME/.npm \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

WORKDIR /label-studio/label_studio/frontend

COPY --chown=1001:0 label_studio/frontend .
COPY --chown=1001:0 label_studio/__init__.py /label-studio/label_studio/__init__.py

RUN --mount=type=cache,target=$NPM_CACHE_LOCATION,uid=1001,gid=0 \
    npm ci \
 && npm run build:production

FROM registry.access.redhat.com/ubi8/python-39

ENV LS_DIR=/label-studio \
    PIP_CACHE_DIR=$HOME/.cache \
    DJANGO_SETTINGS_MODULE=core.settings.label_studio \
    LABEL_STUDIO_BASE_DATA_DIR=/label-studio/data

WORKDIR $LS_DIR

# Copy and install middleware dependencies
COPY --chown=1001:0 deploy/requirements-mw.txt .
RUN --mount=type=cache,target=$PIP_CACHE_DIR,uid=1001,gid=0 \
    pip3 install --no-cache-dir -r requirements-mw.txt

# Copy and install requirements.txt first for caching
COPY --chown=1001:0 deploy/requirements.txt .
RUN --mount=type=cache,target=$PIP_CACHE_DIR,uid=1001,gid=0 \
    pip3 install --no-cache-dir -r requirements.txt

COPY --chown=1001:0 . .
RUN --mount=type=cache,target=$PIP_CACHE_DIR,uid=1001,gid=0 \
    pip3 install --no-cache-dir -e .

RUN rm -rf ./label_studio/frontend
COPY --chown=1001:0 --from=frontend-builder /label-studio/label_studio/frontend/dist ./label_studio/frontend/dist

RUN python3 label_studio/manage.py collectstatic --no-input

EXPOSE 8080

LABEL name="LabelStudio" \
  maintainer="infra@heartex.com" \
  vendor="Heartex" \
  version="1.5.0dev" \
  release="1" \
  summary="LabelStudio" \
  description="Label Studio is an open source data labeling tool."

COPY --chown=1001:0 licenses/ /licenses
RUN cp $LS_DIR/LICENSE /licenses

ENTRYPOINT ["./deploy/docker-entrypoint.sh"]
CMD ["label-studio"]