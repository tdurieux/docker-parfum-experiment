FROM python:3.7-stretch
RUN mkdir /nameko
WORKDIR /nameko
ADD requirements.txt /nameko
RUN pip install --no-cache-dir -r /nameko/requirements.txt
ADD nameko_example.py /nameko/

