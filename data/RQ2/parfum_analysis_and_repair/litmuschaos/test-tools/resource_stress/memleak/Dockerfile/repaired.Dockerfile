FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        fio \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;


COPY [ "memleak.py","long_file.txt","/"]

CMD ["python memleak.py"]
