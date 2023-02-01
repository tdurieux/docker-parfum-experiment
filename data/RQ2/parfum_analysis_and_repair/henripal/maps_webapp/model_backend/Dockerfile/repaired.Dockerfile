FROM continuumio/miniconda3


RUN apt update && apt install --no-install-recommends -y python3-dev gcc && rm -rf /var/lib/apt/lists/*;

# Install pytorch and fastai
RUN conda install -c pytorch pytorch-nightly-cpu
RUN conda install -c fastai torchvision-nightly-cpu
RUN conda install -c fastai fastai

# Install starlette and uvicorn
RUN pip install --no-cache-dir starlette uvicorn python-multipart aiohttp

ADD cities.py cities.py
ADD  resnet50-big-finetuned-bs64.pth resnet50-big-finetuned-bs64.pth

# Run it once to trigger resnet download
RUN python cities.py

EXPOSE 8008

# Start the server
CMD ["python", "cities.py", "serve"]
