FROM ubuntu:latest
RUN apt-get update -y && apt-get install --no-install-recommends -y python-pip python-dev build-essential && rm -rf /var/lib/apt/lists/*;
COPY . /app
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
RUN echo "HackDef{SSTI_th3_n3w_SQLi}" >> /tmp/flag
ENTRYPOINT ["python"]
CMD ["app.py"]
