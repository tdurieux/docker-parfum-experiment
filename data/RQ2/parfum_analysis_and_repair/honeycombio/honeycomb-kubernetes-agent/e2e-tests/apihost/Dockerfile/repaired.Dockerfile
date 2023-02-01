FROM python
RUN pip install --no-cache-dir flask zstd
ADD ./server.py /
ENTRYPOINT ["python", "server.py"]
