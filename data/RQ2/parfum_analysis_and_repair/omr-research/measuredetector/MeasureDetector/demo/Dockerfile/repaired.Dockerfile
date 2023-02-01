FROM tensorflow/tensorflow:1.13.1-py3

RUN apt-get update && apt-get install --no-install-recommends -y jq curl && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir pillow hug
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

WORKDIR /usr/src/app
COPY inference_server.py .
# Get latest model
RUN curl -f -L $( curl -f -sL https://api.github.com/repos/OMR-Research/MeasureDetector/releases/latest | jq -r '.assets[].browser_download_url') --output model.pb

EXPOSE 8080
CMD ["hug", "-p=8080", "-f=inference_server.py"]