FROM python:3.6

RUN pip install --no-cache-dir vibora
ADD app_vibora.py app.py
ENTRYPOINT ["python", "app.py"]
