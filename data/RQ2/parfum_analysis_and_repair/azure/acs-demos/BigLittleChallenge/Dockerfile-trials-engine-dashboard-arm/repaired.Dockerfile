FROM armhf/python:3.6

RUN pip install --no-cache-dir --upgrade pip

COPY trials-engine-dashboard/requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 80

COPY trials-engine-dashboard/src src

ENTRYPOINT [ "python", "src/server.py"]