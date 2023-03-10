FROM python:3.8-slim
RUN pip install --no-cache-dir numpy==1.19.1 scipy==1.5.2 scikit-learn==0.23.1 numba==0.50.1 networkx==2.4 && \
    rm -rf ~/.cache
COPY config.json /
COPY penguin_judge_agent /bin
CMD ["/bin/penguin_judge_agent"]
