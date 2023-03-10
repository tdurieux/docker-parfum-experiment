FROM registry.access.redhat.com/ubi8/ubi-minimal

ARG OPERATOR_VERSION
LABEL "name"="H2O Open Source Machine Learning Operator"
LABEL "vendor"="H2O.ai"
LABEL "version"=${OPERATOR_VERSION}
LABEL "release"=${OPERATOR_VERSION}
LABEL "summary"="An operator for H2O Open Source Machine Learning platform"
LABEL "description"="H2O is an Open Source, Distributed, Fast & Scalable Machine Learning Platform: Deep Learning, Gradient Boosting (GBM) & XGBoost, Random Forest, Generalized Linear Modeling (GLM with Elastic Net), K-Means, PCA, Generalized Additive Models (GAM), RuleFit, Support Vector Machine (SVM), Stacked Ensembles, Automatic Machine Learning (AutoML), etc."

# Install latest STABLE rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN source $HOME/.cargo/env
ENV PATH=/root/.cargo/bin:$PATH

# Install dependencies required to compile H2O Kubernetes Operator
RUN microdnf install make cmake openssl-devel gcc

# Compile H2O Kubernetes Operator
COPY . /opt/h2o-operator/
RUN cd /opt/h2o-operator/ && cargo update && cargo build --release
RUN mkdir /opt/h2oai && cp /opt/h2o-operator/target/release/h2o-operator /opt/h2oai/

# Copy project's license into the container (required by Red Hat for certification)
RUN mkdir /licenses
COPY LICENSE /licenses

# Clean compilation dependencies up
RUN rustup self uninstall -y
RUN microdnf remove make cmake cmake-data openssl-devel gcc && microdnf clean all
RUN rm /opt/h2o-operator/ -rf

CMD /opt/h2oai/h2o-operator