FROM python:3.7

COPY requirements.txt /opt/
RUN pip3 install --no-cache-dir -r /opt/requirements.txt


COPY app.py /opt/

WORKDIR /opt
CMD ["flask", "run", "--host", "0.0.0.0", "--port", "5000"]

