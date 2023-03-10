FROM tiangolo/uvicorn-gunicorn:python3.8-slim

RUN apt-get update

# Install for all languages
# RUN apt-get install tesseract-ocr-all -y

# Install only for en
RUN apt-get install --no-install-recommends tesseract-ocr -y && rm -rf /var/lib/apt/lists/*;

# Additional install for Chinese Simplified. RUN apt list tesseract* to see available packages.
RUN apt-get install -y --no-install-recommends tesseract-ocr-chi-sim && rm -rf /var/lib/apt/lists/*;

RUN python -m pip install --upgrade pip

RUN mkdir /fastapi

COPY requirements.txt /fastapi

WORKDIR /fastapi

RUN pip install --no-cache-dir -r requirements.txt

COPY . /fastapi

EXPOSE 8088

COPY ./start.sh /start.sh

RUN chmod +x /start.sh

CMD ["/start.sh"]
