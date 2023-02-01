# Basic docker image for Map-a-Droid
# Usage:
#   docker build -t mad .                 # Build the docker Image
#   docker run -d mad startWalker.py -os  # Launch Walker
#   docker run -d mad startWalker.py -oo  # Launch Screenshot Processing
#   docker run -d mad startWalker.py -wm  # Launch MAdmin

FROM python:2.7-slim

# Default port the webserver runs on
EXPOSE 5000

# Working directory for the application
WORKDIR /usr/src/app

# Set Entrypoint with hard-coded options
ENTRYPOINT ["python"]
CMD ["./startWalker.py"]

# Install required system packages
RUN apt-get update && apt-get install -y --no-install-recommends libgeos-dev build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get -y --no-install-recommends install libglib2.0-0 && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get -y --no-install-recommends install tesseract-ocr libtesseract-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install tk && rm -rf /var/lib/apt/lists/*;
RUN apt-get update

COPY requirements.txt /usr/src/app/

RUN pip install --no-cache-dir -r requirements.txt

# Copy everything to the working directory (Python files, templates, config) in one go.
COPY . /usr/src/app/
