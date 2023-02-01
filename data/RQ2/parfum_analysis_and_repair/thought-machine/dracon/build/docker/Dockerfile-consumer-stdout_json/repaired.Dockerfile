FROM python:3.7-alpine
RUN adduser --shell /bin/false -u 1000 -D app
COPY --chown=app:app . /home/app/dracon

WORKDIR /home/app/dracon/
RUN pip3 install --no-cache-dir protobuf google

USER app
ENV PYTHONPATH=$PYTHONPATH:/home/app/dracon
ENTRYPOINT ["python3","/home/app/dracon/consumers/stdout_json/stdout_json.py"]
