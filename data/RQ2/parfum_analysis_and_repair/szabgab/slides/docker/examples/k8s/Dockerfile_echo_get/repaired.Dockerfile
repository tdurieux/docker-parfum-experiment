FROM python:3.7
RUN pip install --no-cache-dir flask
ENV FLASK_APP echo_get
WORKDIR /opt
COPY  echo_get.py .
CMD ["flask", "run", "--host", "0.0.0.0"]
