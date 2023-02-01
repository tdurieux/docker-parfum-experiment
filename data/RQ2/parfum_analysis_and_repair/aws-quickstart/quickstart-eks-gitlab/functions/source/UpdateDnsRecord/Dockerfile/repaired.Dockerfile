FROM lambci/lambda:build-python3.8

COPY . .

RUN zip -X -r lambda.zip .

CMD mkdir -p /output/ && mv lambda.zip /output/