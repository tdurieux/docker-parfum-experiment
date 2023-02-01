FROM python:alpine
WORKDIR /app
COPY . .
ENV PYTHONUNBUFFERED=1
RUN pip install --no-cache-dir -r requirements.txt
CMD ["python", "app/app.py"]
