FROM matrix-python3:1.0

WORKDIR /server

EXPOSE 9000

ADD server.tar /server

CMD ["python", "server.py"]