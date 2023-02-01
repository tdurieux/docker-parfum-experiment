FROM python:3.6.8-jessie
RUN mkdir /app
WORKDIR /app
COPY requirements.txt .
COPY requirements_dev.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -r requirements_dev.txt
ADD . .
