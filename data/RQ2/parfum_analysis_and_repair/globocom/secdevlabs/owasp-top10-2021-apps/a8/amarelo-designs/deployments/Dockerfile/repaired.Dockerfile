FROM python:3
WORKDIR /app
ADD app/requirements.txt /app/requirements.txt
RUN apt-get update && apt-get -y --no-install-recommends install netcat && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r requirements.txt
CMD python app.py