FROM python:3.7.3-alpine3.10

### install some python3 dependencies
RUN apk add --no-cache gcc musl-dev
RUN pip3 install --no-cache-dir eth_abi

COPY ./src /app

ENTRYPOINT ["python", "/app/app.py"]
