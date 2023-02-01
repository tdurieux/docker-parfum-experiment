FROM python:3.8
RUN pip install --no-cache-dir asreview asreview-datatools asreview-insights
ENTRYPOINT ["asreview"]
ENV ASREVIEW_PATH=project_folder
