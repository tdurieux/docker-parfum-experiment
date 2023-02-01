FROM $BASE_IMAGE

COPY custom_requirements.txt custom_requirements.txt

RUN pip install --no-cache-dir -r custom_requirements.txt