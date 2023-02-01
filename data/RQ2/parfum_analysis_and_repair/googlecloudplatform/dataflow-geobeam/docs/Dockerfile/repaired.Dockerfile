FROM python:3.8-buster

RUN apt update && apt install --no-install-recommends latexmk texlive-latex-recommended texlive-pictures texlive-latex-extra -y && rm -rf /var/lib/apt/lists/*;
RUN python -m pip install sphinx m2r2 apache_beam
