FROM python:3.6

WORKDIR /app

COPY . /app

# Update apt-get
RUN apt-get update && apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*; # Install git


# Updrade pip
RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir -r requirements_dev.txt

RUN pip install --no-cache-dir -e .

COPY configuration/docker.ini /root/.variantvalidator

CMD python3 bin/variant_validator.py
