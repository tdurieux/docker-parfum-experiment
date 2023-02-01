FROM python:3.10-slim

WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends -y sqlite3 gcc build-essential python3-dev libxslt-dev libffi-dev libssl-dev && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt ./
RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir -Ur requirements.txt

COPY . .

CMD ["python3", "-m", "carberretta"]
