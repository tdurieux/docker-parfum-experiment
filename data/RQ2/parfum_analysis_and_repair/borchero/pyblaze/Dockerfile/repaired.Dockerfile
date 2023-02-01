FROM python:3.7

RUN apt-get update && apt-get install --no-install-recommends -y pandoc && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pylint twine sphinx sphinx-rtd-theme nbsphinx wandb ipython

COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
