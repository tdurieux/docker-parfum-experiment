ARG PYTHON_ALPINE_VERSION

FROM python:$PYTHON_ALPINE_VERSION

# Build Args
ARG CMSEEK_DOWNLOAD_URL

# Content
WORKDIR /cmseek
ADD $CMSEEK_DOWNLOAD_URL cmseek.tar.gz
RUN tar -xvf cmseek.tar.gz -C /cmseek --strip-components=1 && rm cmseek.tar.gz
ENTRYPOINT ["python", "cmseek.py"]