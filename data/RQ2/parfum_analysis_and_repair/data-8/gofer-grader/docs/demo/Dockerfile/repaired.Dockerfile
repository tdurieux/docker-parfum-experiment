FROM jupyter/minimal-notebook

EXPOSE 8888

COPY Gofer_Demo.ipynb .

COPY tests tests

RUN pip install --no-cache-dir gofer-grader

CMD ["jupyter", "notebook"]
