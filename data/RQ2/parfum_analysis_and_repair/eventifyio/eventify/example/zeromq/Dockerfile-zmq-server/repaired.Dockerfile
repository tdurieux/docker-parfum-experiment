FROM zeromq/zeromq

ADD zmq_server.py /zmq_server.py

EXPOSE 5570

CMD ["python3", "/zmq_server.py"]