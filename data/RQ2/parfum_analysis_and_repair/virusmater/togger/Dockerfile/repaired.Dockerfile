FROM tiangolo/meinheld-gunicorn:latest
COPY . /app
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r requirements.txt
