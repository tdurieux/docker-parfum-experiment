FROM python:3.8

WORKDIR /ia


RUN apt update && apt install -y --no-install-recommends build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*;

COPY ./requirements.txt .

RUN  python3 -m pip install -r requirements.txt

COPY . .

CMD ["python3", "worker.py"]