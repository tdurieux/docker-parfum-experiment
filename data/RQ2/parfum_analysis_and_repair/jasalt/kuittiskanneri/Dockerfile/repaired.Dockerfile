FROM python:2.7
WORKDIR /code

COPY requirements.txt /code/
RUN pip install --no-cache-dir -r requirements.txt

VOLUME /code

CMD ["python", "run.py"]
