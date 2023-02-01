ARG PYTHON_ALPINE_VERSION

FROM python:$PYTHON_ALPINE_VERSION

# Build Args
ARG DIRHUNT_VERSION

# Content
RUN pip install --no-cache-dir dirhunt==$DIRHUNT_VERSION
ENTRYPOINT ["dirhunt"]