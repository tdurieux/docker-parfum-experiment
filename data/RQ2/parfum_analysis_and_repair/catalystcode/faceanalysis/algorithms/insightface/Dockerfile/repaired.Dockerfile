FROM python:3.6

WORKDIR /app
RUN apt-get update && apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;
RUN wget "https://redcrossstorage.blob.core.windows.net/models/insightface.zip" && \
    unzip insightface.zip

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY vectorize.py .

ENTRYPOINT ["python3", "vectorize.py"]
