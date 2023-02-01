FROM python:3.8
ENV PYTHONUNBUFFERED 1
WORKDIR /federated
COPY requirements.txt /federated/requirements.txt
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
COPY . /federated