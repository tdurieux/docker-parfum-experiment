FROM python:3.6-slim AS builder
RUN apt-get update && apt-get install --no-install-recommends -y gcc && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

FROM python:3.6-slim
COPY --from=builder /root/.local /root/.local
COPY . .
ENV PATH=/root/.local/bin:$PATH
ENTRYPOINT bash -c "python manage.py makemigrations data && python manage.py migrate data && python telegram.py"