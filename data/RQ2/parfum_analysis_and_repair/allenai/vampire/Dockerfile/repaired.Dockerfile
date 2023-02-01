FROM allennlp/commit:234fb18fc253d8118308da31c9d3bfaa9e346861

LABEL maintainer="suching@allenai.org"

WORKDIR /vampire

RUN pip install --no-cache-dir pandas
RUN pip install --no-cache-dir pytest
RUN pip install --no-cache-dir torchvision
RUN pip install --no-cache-dir tabulate
RUN pip install --no-cache-dir regex
RUN pip install --no-cache-dir pylint==1.8.1
RUN pip install --no-cache-dir mypy==0.521
RUN pip install --no-cache-dir codecov
RUN pip install --no-cache-dir pytest-cov

RUN python -m spacy download en

COPY scripts/ scripts/
COPY environments/ environments/
COPY vampire/ vampire/
COPY training_config/ training_config/
COPY .pylintrc .pylintrc

# Optional argument to set an environment variable with the Git SHA
ARG SOURCE_COMMIT
ENV ALLENAI_VAMPIRE_SOURCE_COMMIT $SOURCE_COMMIT

EXPOSE 8000

ENTRYPOINT ["/bin/bash"]