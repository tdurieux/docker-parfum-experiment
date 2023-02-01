FROM python:3.7

WORKDIR /usr/src/app/src

RUN apt update; apt install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
# ./src is expected to be mounted with a docker volume
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "5000", "--reload"]
