FROM dengdan/tensorflow-gpu
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple torch torchvision

