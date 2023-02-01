FROM python:3.7-slim-buster

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install tesseract and pip
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y python-pip python-dev build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt update && apt install --no-install-recommends -y libsm6 libxext6 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install tesseract-ocr && rm -rf /var/lib/apt/lists/*;

# Create a working directory
COPY . /realtweetornotbot
WORKDIR /realtweetornotbot

# Install requirements
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY ./src .
CMD ["python", "src/main.py"]
