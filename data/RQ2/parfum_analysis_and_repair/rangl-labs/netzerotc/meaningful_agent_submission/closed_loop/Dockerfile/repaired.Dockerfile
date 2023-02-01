FROM python:3.8-slim-buster

WORKDIR /service
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . /service
CMD ["python", "agent.py"]

