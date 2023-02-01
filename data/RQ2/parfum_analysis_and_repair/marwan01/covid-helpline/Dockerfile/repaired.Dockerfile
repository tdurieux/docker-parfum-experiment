FROM python
RUN apt-get update -y && apt-get install --no-install-recommends -y python3-pip python3-dev build-essential && rm -rf /var/lib/apt/lists/*;
COPY . /app
WORKDIR /app/src
RUN pip3 install --no-cache-dir -r requirements.txt
RUN export GOOGLE_APPLICATION_CREDENTIALS=keys.json
ENTRYPOINT ["python3"]
CMD ["main.py"]