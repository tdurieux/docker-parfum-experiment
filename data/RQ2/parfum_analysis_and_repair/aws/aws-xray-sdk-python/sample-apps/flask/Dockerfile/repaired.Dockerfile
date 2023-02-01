FROM python:3.6

WORKDIR /app

COPY . ./

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "application.py"]
