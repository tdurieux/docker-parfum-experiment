FROM python:3.7

RUN pip install --no-cache-dir gunicorn

WORKDIR /app
COPY requirements.txt /app

RUN pip install --no-cache-dir -r requirements.txt

COPY website /app/website
COPY ctr1.py /app/

EXPOSE 5000/tcp

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "ctr1:app"]