# python is image I am using as the basic installation
# that supports all required python packages
FROM python:slim

# Install python packages:
RUN apt-get update && apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;

ENV PYTHONPATH=/usr/lib/python3.8/site-packages/

# Installing other packages:
RUN pip3 install --no-cache-dir --upgrade pip
COPY ./requirments.txt /tmp/
RUN pip3 install --no-cache-dir -r /tmp/requirments.txt

# Copy code to image:
RUN mkdir /Sumerian_extraction
COPY . ./Sumerian_extraction


WORKDIR ./Sumerian_extraction

# Expose a port to access the API:
EXPOSE 8080

# Run `python3 pipeline.py`
ENTRYPOINT ["python3"]
CMD ["main.py"]
