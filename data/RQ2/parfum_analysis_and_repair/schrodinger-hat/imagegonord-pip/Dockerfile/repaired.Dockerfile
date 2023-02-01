FROM python:3.9-slim

WORKDIR /app
COPY upload-release.sh .

RUN pip install --no-cache-dir twine && pip install --no-cache-dir setuptools

RUN chmod +x upload-release.sh
ENTRYPOINT [ "/app/upload-release.sh" ]