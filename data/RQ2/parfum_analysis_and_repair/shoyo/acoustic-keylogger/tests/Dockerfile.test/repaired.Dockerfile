FROM python:3.8
WORKDIR /env
COPY ./tests/requirements.txt /env/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY . /env
