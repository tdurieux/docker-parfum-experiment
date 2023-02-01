FROM workflow_base

RUN apt-get clean
RUN apt-get update && apt-get install --no-install-recommends -y tesseract-ocr libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir pillow opencv-python pytesseract

COPY main.py /proxy/main.py