FROM lambci/lambda:build-python3.8

COPY . .

RUN pip install -t . -r ./requirements.txt && \
    zip -X -r lambda.zip .

CMD mkdir -p /output/ && mv lambda.zip /output/