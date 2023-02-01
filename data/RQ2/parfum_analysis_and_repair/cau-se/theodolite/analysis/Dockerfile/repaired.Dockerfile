FROM jupyter/base-notebook

COPY . /home/jovyan

WORKDIR /home/jovyan
RUN rm -r work
RUN pip install --no-cache-dir -r requirements.txt
