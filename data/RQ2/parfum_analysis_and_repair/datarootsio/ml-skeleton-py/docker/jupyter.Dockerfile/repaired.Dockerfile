FROM python:3.7
RUN apt-get update && apt-get install --no-install-recommends -y python-dev libffi-dev build-essential && rm -rf /var/lib/apt/lists/*;
WORKDIR /workspace
COPY ./setup.py /workspace
RUN pip install --no-cache-dir .
RUN pip install --no-cache-dir jupyter
EXPOSE 8888
ENTRYPOINT ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
