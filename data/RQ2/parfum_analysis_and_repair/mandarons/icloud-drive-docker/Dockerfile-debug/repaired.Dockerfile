FROM python:3.9-alpine AS build
RUN apk update && apk add --no-cache git gcc musl-dev python3-dev libffi-dev openssl-dev cargo
WORKDIR /app
COPY requirements.txt .
RUN python -m venv venv
ENV PATH="/app/venv/bin/:$PATH"
RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir debugpy
FROM python:3.9-alpine
WORKDIR /app
COPY --from=build /app/venv /app/venv
ENV PATH="/app/venv/bin/:$PATH"
ENV PYTHONPATH /app
# Map local folder to /app instead
#COPY . /app/

EXPOSE 5678
# Run below command
#CMD ["python", "-m", "debugpy","--listen", "0.0.0.0:5678", "--wait-for-client", "./src/main.py"]
