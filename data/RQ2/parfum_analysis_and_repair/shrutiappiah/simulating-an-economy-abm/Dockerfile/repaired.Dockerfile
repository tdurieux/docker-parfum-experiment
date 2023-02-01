FROM amancevice/pandas:latest

RUN pip install --no-cache-dir mesa

COPY requirements.txt /tmp/requirements.txt

RUN pip install --no-cache-dir -r /tmp/requirements.txt

RUN mkdir /usr/local/models

COPY *.py /usr/local/models/

CMD ["python", "/usr/local/models/VisualizeEconomy.py"]