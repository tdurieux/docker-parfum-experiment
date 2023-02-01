FROM $DOCKER_IMAGE_NAME

ADD . /app/
RUN pip install --no-cache-dir -r /app/requirements.txt
