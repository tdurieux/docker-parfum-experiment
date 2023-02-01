FROM python:3

COPY main.py /
COPY .lib /
COPY requirements.txt /

RUN pip3 install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python3", "main.py"]
