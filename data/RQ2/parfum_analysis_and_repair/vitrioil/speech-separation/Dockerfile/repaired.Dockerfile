FROM nvcr.io/nvidia/pytorch:19.11-py3

COPY requirements.txt .
COPY setup.sh .

RUN apt update && apt install --no-install-recommends -y ffmpeg sox && rm -rf /var/lib/apt/lists/*;
RUN apt upgrade -y



RUN pip install --no-cache-dir --upgrade git+https://github.com/ytdl-org/youtube-dl.git@master
RUN pip install --no-cache-dir -r requirements.txt

RUN chmod +x setup.sh
RUN ./setup.sh
