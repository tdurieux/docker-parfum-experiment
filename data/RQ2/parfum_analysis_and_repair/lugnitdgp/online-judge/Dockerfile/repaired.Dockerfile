FROM python:3
ENV PYTHONBUFFERED 1
RUN mkdir /backend
WORKDIR /backend
COPY requirements.txt /backend/
RUN pip install --no-cache-dir -r requirements.txt
COPY . /backend/
