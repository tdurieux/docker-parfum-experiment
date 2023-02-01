FROM arm32v7/python:3.7-slim-buster

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Code added to support Custom Vision app in the Azure IoT Module
RUN apt update && apt install --no-install-recommends -y libjpeg62-turbo libopenjp2-7 libtiff5 libatlas-base-dev libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir absl-py six protobuf wrapt gast astor termcolor keras_applications keras_preprocessing --no-deps
RUN pip install --no-cache-dir numpy==1.16 tensorflow==1.13.1 --extra-index-url 'https://www.piwheels.org/simple' --no-deps
RUN pip install --no-cache-dir flask pillow --index-url 'https://www.piwheels.org/simple'

# Expose the port
EXPOSE 8089

COPY . .

# use default launch for the python app
# Run the flask server for the endpoints
CMD python -u main.py