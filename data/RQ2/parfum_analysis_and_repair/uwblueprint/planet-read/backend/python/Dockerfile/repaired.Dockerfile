FROM python:3.7

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app

WORKDIR /app

EXPOSE 5000
CMD ["python", "wsgi.py"]
