FROM paddlepaddle/paddle:latest-dev-rocm4.0-miopen2.11

# clone
WORKDIR /opt/
RUN git clone https://github.com/PaddlePaddle/PaddleScience.git

# env
RUN chmod 777 -R /opt/PaddleScience/examples
ENV PYTHONPATH /opt/PaddleScience

# install requirements
WORKDIR /opt/PaddleScience
RUN pip install --no-cache-dir --upgrade --ignore-installed pip
RUN pip install --no-cache-dir --pre paddlepaddle-rocm -f https://www.paddlepaddle.org.cn/whl/rocm/develop.html
RUN pip install --no-cache-dir -r /opt/PaddleScience/requirements.txt -i https://mirror.baidu.com/pypi/simple
RUN pip install --no-cache-dir wget

# download datasets
WORKDIR /opt/PaddleScience
RUN mkdir -p ./examples/cylinder/3d_unsteady_discrete/baseline/openfoam_cylinder_re100
WORKDIR /opt/PaddleScience/examples/cylinder/3d_unsteady_discrete/baseline/openfoam_cylinder_re100
RUN wget https://dataset.bj.bcebos.com/PaddleScience/cylinder3D/openfoam_cylinder_re100/cylinder3d_openfoam_re100.zip
RUN unzip cylinder3d_openfoam_re100.zip

WORKDIR /opt/PaddleScience
RUN mkdir -p .//examples/cylinder/3d_unsteady_discrete/optimize/openfoam_cylinder_re100
WORKDIR /opt/PaddleScience/examples/cylinder/3d_unsteady_discrete/optimize/openfoam_cylinder_re100
RUN wget https://dataset.bj.bcebos.com/PaddleScience/cylinder3D/openfoam_cylinder_re100/cylinder3d_openfoam_re100.zip
RUN unzip cylinder3d_openfoam_re100.zip

WORKDIR /opt/PaddleScience/examples/cylinder/2d_unsteady_continuous
RUN python download_dataset.py

WORKDIR /opt/PaddleScience

# CMD ["sleep", "infinity"]
