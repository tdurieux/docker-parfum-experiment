FROM python:3.6-alpine
ADD . /code
WORKDIR /code
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -e .
CMD ["python", "reducepy/app.py"]
