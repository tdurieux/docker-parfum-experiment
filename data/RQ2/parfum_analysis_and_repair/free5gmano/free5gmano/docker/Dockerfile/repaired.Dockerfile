FROM ubuntu:20.04

RUN apt update && apt install --no-install-recommends -y libssl-dev python3-pip git libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /
RUN git clone https://github.com/free5gmano/free5gmano.git
WORKDIR free5gmano/
RUN pip3 install --no-cache-dir -r requirements.txt

CMD python3 manage.py makemigrations moi nssmf FaultManagement && python3 manage.py migrate && python3 manage.py runserver 0.0.0.0:8000

