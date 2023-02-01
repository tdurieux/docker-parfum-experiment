FROM python:3.6

RUN pip install --no-cache-dir matplotlib numpy pandas seaborn statsmodels scipy hic-straw requests

RUN git clone https://github.com/ay-lab/selfish/
