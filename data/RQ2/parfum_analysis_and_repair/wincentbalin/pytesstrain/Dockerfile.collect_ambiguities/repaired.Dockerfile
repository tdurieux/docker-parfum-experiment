FROM ubuntu:16.04
RUN apt-get update && \
    apt-get install --no-install-recommends -y python3-pip tesseract-ocr && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
COPY *.ttf /usr/share/fonts/truetype/
COPY *.traineddata /usr/share/tesseract-ocr/tessdata/
COPY *.wordlist .
COPY dist/*.whl .
RUN pip3 install --no-cache-dir *.whl && \
    rm *.whl
