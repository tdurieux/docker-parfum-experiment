FROM python:3.6-alpine
ADD . /code
WORKDIR /code
RUN pip install --no-cache-dir redis flask
CMD ["python", "app.py"]
