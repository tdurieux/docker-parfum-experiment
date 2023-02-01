FROM python:3-slim

RUN apt-get update && apt-get install --no-install-recommends --yes zip && rm -rf /var/lib/apt/lists/*;

ADD app/app.py .
ADD app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

CMD python app.py