ARG PYTHON_ALPINE_VERSION

FROM python:$PYTHON_ALPINE_VERSION

# Build Args
ARG DOWNLOAD_URL

# Content
WORKDIR /code
ADD $DOWNLOAD_URL code.tar.gz
RUN tar -xvf code.tar.gz -C /code --strip-components=1 \
    && pip install --no-cache-dir -r requirements.txt && rm code.tar.gz
ENTRYPOINT ["python", "xsstrike.py"]
CMD ["--help"]