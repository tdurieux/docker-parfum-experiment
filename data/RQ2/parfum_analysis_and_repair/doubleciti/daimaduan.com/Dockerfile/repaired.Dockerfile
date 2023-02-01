FROM python:2.7
ADD requirements.txt /root/requirements.txt
RUN pip install --no-cache-dir -r /root/requirements.txt
