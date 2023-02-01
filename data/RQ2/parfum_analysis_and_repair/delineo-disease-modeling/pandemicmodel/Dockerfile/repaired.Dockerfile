FROM python:3.9

WORKDIR /PandemicModel

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY /simulation .