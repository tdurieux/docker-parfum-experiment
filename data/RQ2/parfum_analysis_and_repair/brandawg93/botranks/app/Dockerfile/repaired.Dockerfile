FROM python:alpine
COPY . .
RUN pip install --no-cache-dir -r requirements.txt