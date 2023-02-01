FROM python:3.8-slim-buster

RUN apt update && apt install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

RUN mkdir /code
COPY . /code
WORKDIR /code
RUN pip install --no-cache-dir -r requirements.txt
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]