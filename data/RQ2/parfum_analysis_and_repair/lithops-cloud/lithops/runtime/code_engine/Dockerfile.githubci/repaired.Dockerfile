FROM jsampe/lithops-codeengine-v38:latest

# Copy Lithops proxy and lib to the container image.
ENV APP_HOME /lithops
WORKDIR $APP_HOME

COPY lithops_codeengine.zip .
RUN rm -rf lithops && unzip -o lithops_codeengine.zip && rm lithops_codeengine.zip