FROM a2i2/hydra_example:latest

RUN pip3 install --no-cache-dir jupyter -U && pip3 install --no-cache-dir jupyterlab

EXPOSE 8888

# TODO: Remove token and password settings for production deployment
CMD ["jupyter", "lab","--allow-root", "--ip=0.0.0.0", "--no-browser","--NotebookApp.token=''","--NotebookApp.password=''"]
