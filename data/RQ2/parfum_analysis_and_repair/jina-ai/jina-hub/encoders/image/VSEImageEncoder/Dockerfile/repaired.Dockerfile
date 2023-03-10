FROM pytorch/pytorch:1.6.0-cuda10.1-cudnn7-runtime

RUN apt-get update && apt-get install --no-install-recommends -y git wget && rm -rf /var/lib/apt/lists/*;
RUN wget https://www.cs.toronto.edu/~faghri/vsepp/runs.tar && tar -xvf runs.tar && rm -rf runs/coco* && rm -rf runs/f30k_vse0/ && \
rm -rf runs/f30k_order*/ && rm -rf runs/f30k_vse++/ && rm -rf runs/f30k_vse++_resnet* && rm -rf runs/f30k_vse++_vggfull_finetune/ && \
rm -rf runs.tar

COPY . /workspace
WORKDIR /workspace

RUN pip install --no-cache-dir -r requirements.txt && \
python -c "import torchvision.models as models; model = getattr(models, 'vgg19')(pretrained=True).eval()"

RUN pip install --no-cache-dir pytest && pytest -v -s

ENTRYPOINT ["jina", "pod", "--uses", "config.yml"]
