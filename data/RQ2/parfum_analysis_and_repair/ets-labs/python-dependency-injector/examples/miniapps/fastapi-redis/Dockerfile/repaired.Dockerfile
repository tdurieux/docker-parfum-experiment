FROM python:3.9-buster

ENV PYTHONUNBUFFERED=1

WORKDIR /code
COPY . /code/

RUN pip install --no-cache-dir -r requirements.txt

CMD ["uvicorn", "fastapiredis.application:app", "--host", "0.0.0.0"]
