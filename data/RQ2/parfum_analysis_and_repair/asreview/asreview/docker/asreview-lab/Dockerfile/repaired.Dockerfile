FROM python:3.8
RUN pip install --no-cache-dir asreview
ENTRYPOINT ["asreview","lab","--ip","0.0.0.0"]
ENV ASREVIEW_PATH=project_folder
