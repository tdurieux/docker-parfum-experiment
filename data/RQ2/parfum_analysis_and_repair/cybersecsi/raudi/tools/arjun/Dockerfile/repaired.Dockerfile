ARG PYTHON_ALPINE_VERSION

FROM python:$PYTHON_ALPINE_VERSION

# Build Args
ARG PIP_VERSION

# Content
RUN pip install --no-cache-dir arjun==$PIP_VERSION
ENTRYPOINT ["arjun"]
CMD ["--help"]