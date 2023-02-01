from python:latest
COPY . .
RUN pip install --no-cache-dir -r requirements.txt
CMD flask run --host=0.0.0.0
