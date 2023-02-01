FROM jjanzic/docker-python3-opencv
WORKDIR /code
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir torch==1.7.1+cpu torchvision==0.8.2+cpu -f https://download.pytorch.org/whl/torch_stable.html
RUN pip install --no-cache-dir ftfy regex tqdm
RUN pip install --no-cache-dir git+https://github.com/openai/CLIP.git
COPY search.py .
CMD [ "python", "-u", "./search.py" ]