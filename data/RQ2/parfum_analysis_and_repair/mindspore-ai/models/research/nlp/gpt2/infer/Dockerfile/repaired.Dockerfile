ARG FROM_IMAGE_NAME
FROM ${FROM_IMAGE_NAME}

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt