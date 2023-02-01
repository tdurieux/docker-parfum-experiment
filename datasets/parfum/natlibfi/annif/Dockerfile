FROM python:3.8-slim-bullseye AS builder

LABEL maintainer="Juho Inkinen <juho.inkinen@helsinki.fi>"

SHELL ["/bin/bash", "-c"]
ARG optional_dependencies=dev,voikko,pycld3,fasttext,nn,omikuji,yake,spacy
# Bulding fastText needs some system packages
RUN if [[ $optional_dependencies =~ "fasttext" ]]; then \
		apt-get update && \
		apt-get install -y --no-install-recommends \
			build-essential && \
		pip install --upgrade pip setuptools wheel --no-cache-dir && \
		pip install --no-cache-dir \
			fasttext==0.9.2; \
	fi


FROM python:3.8-slim-bullseye

SHELL ["/bin/bash", "-c"]
COPY --from=builder /usr/local/lib/python3.8 /usr/local/lib/python3.8

ARG optional_dependencies=dev,voikko,pycld3,fasttext,nn,omikuji,yake,spacy
# Install system dependencies needed at runtime:
RUN apt-get update && \
	if [[ $optional_dependencies =~ "voikko" ]]; then \
		apt-get install -y --no-install-recommends \
			libvoikko1 \
			voikko-fi; \
	fi && \
	# curl for Docker healthcheck and rsync for model transfers:
	apt-get install -y --no-install-recommends curl rsync && \
	rm -rf /var/lib/apt/lists/* /usr/include/*

WORKDIR /Annif
RUN pip install --upgrade pip wheel --no-cache-dir

COPY setup.py README.md LICENSE.txt projects.cfg.dist /Annif/
RUN echo "Installing dependencies for optional features: $optional_dependencies" \
	&& pip install .[$optional_dependencies] --no-cache-dir

# Download nltk data
RUN python -m nltk.downloader punkt -d /usr/share/nltk_data

# Download spaCy models, if the optional feature was selected
ARG spacy_models=en_core_web_sm
RUN if [[ $optional_dependencies =~ "spacy" ]]; then \
		for model in $(echo $spacy_models | tr "," "\n"); do \
			python -m spacy download $model; \
		done; \
	fi

# Install Annif by copying source and make the installation editable:
COPY annif /Annif/annif
COPY tests /Annif/tests
RUN pip install -e .

WORKDIR /annif-projects

# Switch user to non-root:
RUN groupadd -g 998 annif_user && \
    useradd -r -u 998 -g annif_user annif_user && \
    chown -R annif_user:annif_user /annif-projects
USER annif_user

CMD annif
