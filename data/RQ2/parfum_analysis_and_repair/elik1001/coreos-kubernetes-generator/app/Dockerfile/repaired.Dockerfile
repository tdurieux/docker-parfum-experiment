FROM python:3.6

# Create app directory
WORKDIR /kub-generator

# Install app dependencies
COPY coreos-kubernetes-generator/src/requirements.txt ./

# Install additional requirements
RUN apt-get update && apt-get install --no-install-recommends -y genisoimage && \
ln -s /usr/bin/genisoimage /usr/bin/mkisofs && \
 pip install --no-cache-dir -r requirements.txt && rm -rf /var/lib/apt/lists/*;

# Bundle app source
COPY coreos-kubernetes-generator /kub-generator

# Entry point
CMD [ "python", "./generate_template.py" ]
