FROM {{ cookiecutter.base_docker_image  }}
ADD requirements.txt /build/requirements.txt
WORKDIR /build/
RUN pip install --no-cache-dir -r requirements.txt
WORKDIR /mnt/
