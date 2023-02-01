FROM pynidm:latest

RUN pip3 install --no-cache-dir flask flask_restful flask-cors

EXPOSE 5000
CMD ["python", "/opt/project/rest-server.py"]
