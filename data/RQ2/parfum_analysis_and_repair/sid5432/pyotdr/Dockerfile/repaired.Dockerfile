FROM python:3.9-slim

WORKDIR /pyotdr
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
RUN pip install --no-cache-dir .


CMD ["pyotdr"]
