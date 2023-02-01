FROM python:3.10.5-alpine

WORKDIR /app
ADD . /app

# System deps:
RUN apk update && apk add --no-cache python3-dev \
                        gcc \
                        g++ \
                        libc-dev \
                        libffi-dev

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000

CMD ["python", "main.py"]
