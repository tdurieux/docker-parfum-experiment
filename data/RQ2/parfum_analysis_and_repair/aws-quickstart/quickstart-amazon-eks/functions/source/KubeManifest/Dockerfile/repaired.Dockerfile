FROM lambci/lambda:build-python3.7

COPY . .

RUN pip install --no-cache-dir -t . -r ./requirements.txt && \
    pip install --no-cache-dir -t python/ -r ./requirements.txt && \
    find . -name "*.dist-info"  -exec rm -rf {} \; | true && \
    find . -name "*.egg-info"  -exec rm -rf {} \; | true && \
    find . -name "*.pth"  -exec rm -rf {} \; | true && \
    find . -name "__pycache__"  -exec rm -rf {} \; | true && \
    rm Dockerfile requirements.txt && \
    find . -exec touch -t 202007010000.00 {} + && \
    zip -X -r lambda.zip ./

CMD mkdir -p /output/ && mv lambda.zip /output/
