FROM python:2.7-slim

WORKDIR /root
RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/DataSploit/datasploit.git datasploit

WORKDIR datasploit
RUN pip install --no-cache-dir -r requirements.txt
CMD python datasploit_config.py
ENTRYPOINT ["python", "datasploit.py"]
CMD ["--help"]