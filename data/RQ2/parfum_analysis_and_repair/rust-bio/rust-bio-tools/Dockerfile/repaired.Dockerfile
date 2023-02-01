FROM gitpod/workspace-full
RUN sudo apt-get install --no-install-recommends --yes libgsl0-dev && rm -rf /var/lib/apt/lists/*;

USER gitpod
ENV SHELL /bin/bash
RUN wget -qO- https://micromamba.snakepit.net/api/micromamba/linux-64/latest | tar -xvj bin/micromamba
RUN ./bin/micromamba create -n rbt bcftools starcode -c conda-forge -c bioconda
RUN yes | ./bin/micromamba shell init -s bash -p /home/gitpod/micromamba

