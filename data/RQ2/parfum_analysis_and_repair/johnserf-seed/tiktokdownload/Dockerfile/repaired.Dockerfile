FROM python:3.7-slim-bullseye
WORKDIR /app
COPY . .
RUN pip3 install --no-cache-dir -r requirements.txt
CMD ["python3", "TikTokMulti.py"]