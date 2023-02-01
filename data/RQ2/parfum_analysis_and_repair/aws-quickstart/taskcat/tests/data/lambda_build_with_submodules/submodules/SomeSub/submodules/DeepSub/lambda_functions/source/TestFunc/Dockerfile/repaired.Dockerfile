FROM lambci/lambda:build-python3.7

COPY . .

RUN pip install --no-cache-dir -t . -r ./requirements.txt && \
    rm -rf *.dist-info *.pth && \
    rm Dockerfile requirements.txt

CMD mkdir -p /output && zip -FS -r /output/lambda.zip ./
