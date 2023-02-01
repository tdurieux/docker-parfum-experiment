# This file is used to execute e2e tests for the project.
FROM python:2.7-alpine
RUN pip install --no-cache-dir webapp2 && \
 pip install --no-cache-dir webob && \
 pip install --no-cache-dir gunicorn
COPY app.py /root/
COPY app.yaml /root/
WORKDIR /root/
# Replace this line with a realistic test script.
ENTRYPOINT ["gunicorn", "-b 0.0.0.0:8000", "app:app"]
