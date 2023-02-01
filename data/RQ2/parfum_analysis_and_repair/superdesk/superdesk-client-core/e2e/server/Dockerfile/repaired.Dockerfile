FROM python:3.8

ADD requirements.txt .
RUN pip3 install --no-cache-dir -U pip wheel setuptools
RUN pip3 install --no-cache-dir -r requirements.txt

WORKDIR /opt/superdesk
COPY . /opt/superdesk

EXPOSE 5000
EXPOSE 5100

ENTRYPOINT ["honcho"]
CMD ["start"]
