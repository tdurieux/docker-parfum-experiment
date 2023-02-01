FROM python:3.5.7
WORKDIR /code
ADD ./requirements.txt /code/requirements.txt
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt