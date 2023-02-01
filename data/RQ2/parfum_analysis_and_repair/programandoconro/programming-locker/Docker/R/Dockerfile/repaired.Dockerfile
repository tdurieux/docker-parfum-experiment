FROM debian:latest
RUN apt update -y && apt install --no-install-recommends r-base -y && rm -rf /var/lib/apt/lists/*;
RUN R -e "install.packages(c('randomForest','caret','neuralnet','e1071'))"
