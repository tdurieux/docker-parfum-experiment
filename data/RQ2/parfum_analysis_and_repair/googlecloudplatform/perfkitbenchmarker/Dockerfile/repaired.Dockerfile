FROM python:3.7

WORKDIR /pkb

COPY requirements.txt /pkb

RUN pip install --no-cache-dir -r requirements.txt

COPY . /pkb

RUN pip install --no-cache-dir -r requirements-testing.txt

CMD python -m unittest discover -s tests -p '*test.py' -v
