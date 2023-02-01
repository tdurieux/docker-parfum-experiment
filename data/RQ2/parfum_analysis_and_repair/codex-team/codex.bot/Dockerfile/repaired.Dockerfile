FROM python:3.9-slim-buster


WORKDIR /home/app

RUN pip install --no-cache-dir --upgrade pip
COPY ./requirements.txt /home/app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "main.py"]