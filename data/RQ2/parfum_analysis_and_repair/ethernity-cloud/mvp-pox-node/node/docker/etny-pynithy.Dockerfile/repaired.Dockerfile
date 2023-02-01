FROM localhost:5000/iosif/etny-pynithy:latest

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir --upgrade setuptools
RUN pip3 install --no-cache-dir web3

ENTRYPOINT ["python"]
CMD ["--help"]
