FROM osgeo/gdal:ubuntu-small-3.4.0

RUN apt-get update && \
    apt-get install --no-install-recommends -y python3-pip && \
    rm -rf /var/lib/apt/lists/*

# For debugging, installing the AWS CLI
# RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"  && \
#     unzip awscliv2.zip && \
#     ./aws/install

COPY requirements.txt requirements.txt
RUN python3 -m pip install -r requirements.txt

COPY . /convert
RUN pip install --no-cache-dir -e convert/
CMD ["s3-to-cog"]