FROM python:3.6

COPY . /app

WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt && ./download_styling_models.sh

WORKDIR /data

ENTRYPOINT ["python", "/app/neural_style/neural_style.py"]
