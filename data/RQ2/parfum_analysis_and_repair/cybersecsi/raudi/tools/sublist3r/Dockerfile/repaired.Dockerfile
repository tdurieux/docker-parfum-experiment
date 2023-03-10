ARG PYTHON_ALPINE_VERSION

FROM python:$PYTHON_ALPINE_VERSION

# Build Args
ARG SUBLIST3R_DOWNLOAD_URL

# Content
ADD $SUBLIST3R_DOWNLOAD_URL sublist3r.tar.gz
RUN tar -xvf sublist3r.tar.gz -C /sublist3r --strip-components=1 \
    && pip install --no-cache-dir -r /sublist3r/requirements.txt && rm sublist3r.tar.gz
ENTRYPOINT ["python", "/sublist3r/sublist3r.py"]