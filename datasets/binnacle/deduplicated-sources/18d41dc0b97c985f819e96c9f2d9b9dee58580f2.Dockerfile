# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

FROM jupyter/minimal-notebook:fa77fe99579b

# Do the pip installs as the unprivileged notebook user
USER jovyan

# Upgrade pip
RUN pip install --upgrade pip

# Install dashboard layout and preview within Jupyter Notebook
ADD . /src
RUN pip install /src && \
    jupyter serverextension enable --py nb2kg --sys-prefix

# Run with remote kernel managers
CMD ["jupyter", "notebook", \
     "--NotebookApp.ip=0.0.0.0", \
     "--NotebookApp.session_manager_class=nb2kg.managers.SessionManager", \
     "--NotebookApp.kernel_manager_class=nb2kg.managers.RemoteKernelManager", \
     "--NotebookApp.kernel_spec_manager_class=nb2kg.managers.RemoteKernelSpecManager"]
