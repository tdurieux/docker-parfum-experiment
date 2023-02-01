FROM python:3

WORKDIR /usr/src/app

RUN apt-get update -y

RUN apt-get install --no-install-recommends -y tesseract-ocr && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y python3-opencv && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir git+https://github.com/urbanogilson/SICAR

COPY . .

VOLUME [ "/data" ]

RUN pip list

CMD [ "python", "./examples/docker.py" ]
