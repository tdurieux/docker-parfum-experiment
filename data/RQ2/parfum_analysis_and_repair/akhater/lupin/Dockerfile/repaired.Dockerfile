FROM python:3-slim AS base

FROM base AS build

WORKDIR /app
COPY requirements.txt .

RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential \
    python3 libpython3-dev python3-venv \
    libssl-dev libffi-dev cargo && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir -U pip setuptools wheel && \
    pip3 install --no-cache-dir -r requirements.txt -t /app
RUN find . -name __pycache__ -exec rm -rf -v {} +
COPY . .

FROM base

WORKDIR /app
COPY --from=build /app .

CMD ["python","-u","main.py"]
