FROM lambci/lambda:build-python3.8

WORKDIR /code

COPY . /code/

RUN mkdir -p /asset && \
	python -m pip install --upgrade pip && \
	pip install --no-cache-dir mangum uvicorn fastapi[all] -t /asset

RUN pip install --no-cache-dir /code -t /asset

RUN cp /code/cdk-deployment/lambda/lambda.py /asset/lambda.py

CMD ["echo", "hello world"]