FROM python:3-slim

RUN apt-get update && apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/D4Vinci/Cr3dOv3r.git
WORKDIR Cr3dOv3r/
RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python", "Cr3d0v3r.py"]
