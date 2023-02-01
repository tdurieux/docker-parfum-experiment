FROM tensorflow/tensorflow:1.14.0-gpu-py3

WORKDIR /app

COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --trusted-host pypi.python.org -r requirements.txt

