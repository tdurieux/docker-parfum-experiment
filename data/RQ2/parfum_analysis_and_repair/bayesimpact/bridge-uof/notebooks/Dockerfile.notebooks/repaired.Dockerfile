FROM jupyter/scipy-notebook:latest
COPY * ./
RUN pip3 install --no-cache-dir -r requirements-notebooks.py
