FROM python:3.7-buster
WORKDIR /code
ENV PYTHONUNBUFFERED=1
ENV FLASK_APP=server.py
ENV FLASK_RUN_HOST=0.0.0.0
RUN apt-get install --no-install-recommends -y gcc g++ && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
RUN python -m nltk.downloader stopwords wordnet
EXPOSE 5000
COPY . .
ENTRYPOINT ["python", "server.py"]