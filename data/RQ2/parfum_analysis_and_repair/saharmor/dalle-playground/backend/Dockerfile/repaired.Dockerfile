FROM nvidia/cuda:11.4.3-cudnn8-devel-ubuntu20.04

# expose
EXPOSE 8080

# set working directory
WORKDIR /app

# install pip
RUN apt-get update && apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;

# install git
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# update pip
RUN pip3 install --no-cache-dir --upgrade pip

# add requirements
COPY ./requirements.txt /app/requirements.txt

# install requirements
RUN pip3 install --no-cache-dir -r requirements.txt

# install jax[cuda]
RUN pip3 install --no-cache-dir --upgrade "jax[cuda]" -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html

# add source code
COPY . /app

# run server
CMD python3 app.py --port 8080 --model_version mini
