FROM python:2.7-slim

RUN apt-get update && apt-get install --no-install-recommends -y \
        git && rm -rf /var/lib/apt/lists/*;


RUN git clone https://github.com/anilbaranyelken/tulpar.git

WORKDIR tulpar

RUN pip install --no-cache-dir --requirement requirements

ENTRYPOINT ["python", "tulpar.py"]
CMD ["-h"]