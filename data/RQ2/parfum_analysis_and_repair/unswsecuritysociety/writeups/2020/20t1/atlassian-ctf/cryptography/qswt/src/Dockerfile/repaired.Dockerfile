FROM python:3.7-alpine

COPY requirements.txt /app/

WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app/

EXPOSE 8000/tcp
CMD ["python", "main.py"]
