FROM quay.io/app-sre/packer:latest

# copy in entire workspace
COPY . /osbuild-composer