FROM python:3

ADD gitlab2prov.py /
ADD gitlab2prov/* /gitlab2prov/
ADD requirements.txt /

RUN pip install --no-cache-dir -r requirements.txt

CMD [ "python", "./gitlab2prov.py" ]