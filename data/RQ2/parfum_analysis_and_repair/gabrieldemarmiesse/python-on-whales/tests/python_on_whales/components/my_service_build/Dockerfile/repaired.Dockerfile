FROM python:3.7-slim

RUN pip install --no-cache-dir redis

RUN apt-get update && apt-get install --no-install-recommends -y iputils-ping && rm -rf /var/lib/apt/lists/*;
CMD python -c "print(1); import time; time.sleep(99999)"
