FROM python:2.7

ADD . /src

RUN pip install --no-cache-dir -r /src/requirements.txt

CMD ["python", "/src/page.py"]
