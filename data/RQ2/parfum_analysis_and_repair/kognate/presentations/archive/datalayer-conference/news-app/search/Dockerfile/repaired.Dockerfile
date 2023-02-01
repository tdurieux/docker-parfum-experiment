FROM python:3-alpine
RUN pip install --no-cache-dir openwhisk_docker_action
RUN pip install --no-cache-dir watson_developer_cloud
ADD script.py /
ADD stub.json /
EXPOSE 8080
CMD [ "python", "./script.py" ]
