FROM python:3.10

RUN apt update && apt install --no-install-recommends uuid -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir prefect==1.2.2
