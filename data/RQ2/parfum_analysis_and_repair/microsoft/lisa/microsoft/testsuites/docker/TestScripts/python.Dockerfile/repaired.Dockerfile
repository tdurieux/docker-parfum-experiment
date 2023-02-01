FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends python3 -y && rm -rf /var/lib/apt/lists/*;
COPY helloworld.py ./
ENTRYPOINT ["python3"]
CMD ["/helloworld.py"]
