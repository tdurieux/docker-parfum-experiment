FROM python:3.8-slim

COPY utils/test-deployment .
RUN pip install --no-cache-dir -r requirements.txt

CMD [ "./run_tests.py" ]