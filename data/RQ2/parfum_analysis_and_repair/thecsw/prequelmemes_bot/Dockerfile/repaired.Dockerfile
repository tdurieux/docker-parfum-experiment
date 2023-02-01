FROM python:3.6.5

RUN apt-get update && apt-get install --no-install-recommends -y tesseract-ocr libtesseract-dev python-opencv libleptonica-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR  /app/src

COPY ./ ../
RUN pip install --upgrade --no-cache-dir -r ../requirements.txt

CMD ["python", "main.py"]
