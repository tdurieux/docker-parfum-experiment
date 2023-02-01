FROM python

ADD pricing_import.py /scripts/
ADD requirements.txt /scripts/

ADD wait-for /scripts/

RUN pip install --no-cache-dir -r /scripts/requirements.txt
