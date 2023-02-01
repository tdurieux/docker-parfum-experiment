FROM gnes/gnes:latest-alpine

RUN apk add --no-cache gcc python3-dev musl-dev
RUN pip install --no-cache-dir pyahocorasick

ADD *.py *.yml ./

ENTRYPOINT ["gnes", "index", "--py_path", "keyword.py"]