FROM python:3.7-slim
RUN pip install --no-cache-dir numpy==1.17.4 scipy==1.3.2 scikit-learn==0.21.3 && \
    rm -rf ~/.cache
COPY config.json /
COPY penguin_judge_agent /bin
CMD ["/bin/penguin_judge_agent"]
