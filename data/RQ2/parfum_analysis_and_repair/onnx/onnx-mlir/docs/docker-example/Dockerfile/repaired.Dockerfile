FROM onnxmlirczar/onnx-mlir-dev
WORKDIR /workdir
ENV HOME=/workdir

# 1) Install packages.
ENV PATH=$PATH:/workdir/bin
RUN apt-get update
RUN apt-get install --no-install-recommends -y python-numpy && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN python -m pip install --upgrade pip
RUN apt-get install --no-install-recommends -y gdb && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y lldb && rm -rf /var/lib/apt/lists/*;

# 2) Instal optional packages, comment/uncomment/add as you see fit.
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y emacs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y valgrind && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libeigen3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y clang-format && rm -rf /var/lib/apt/lists/*;
RUN python -m pip install wheel
RUN python -m pip install numpy
RUN python -m pip install torch==1.6.0+cpu torchvision==0.7.0+cpu -f https://download.pytorch.org/whl/torch_stable.html
RUN git clone https://github.com/onnx/tutorials.git
# Install clang
RUN apt-get install --no-install-recommends -y lsb-release wget software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
# For development
RUN apt-get install -y --no-install-recommends ssh-client && rm -rf /var/lib/apt/lists/*;

# 3) When using vscode, copy your .vscode in the Dockerfile dir and
#    uncomment the two lines below.
# WORKDIR /workdir/.vscode
# ADD .vscode /workdir/.vscode

# 4) When using a personal workspace folder, set your workspace sub-directory
#    in the Dockerfile dir and uncomment the two lines below.
# WORKDIR /workdir/workspace
# ADD workspace /workdir/workspace

# 5) Fix git by reattaching head and making git see other branches than main.
WORKDIR /workdir/onnx-mlir
RUN git remote rename origin upstream
RUN git checkout main
RUN git fetch --unshallow
# Add optional personal fork and disable pushing to upstream (best practice).
# RUN git remote add origin https://github.com/<user>/onnx-mlir.git
# RUN git remote set-url --push upstream no_push

# 6) Set the PATH environment vars for make/debug mode. Replace Debug
#    with Release in the PATH below when using Release mode.
WORKDIR /workdir
ENV NPROC=4
ENV PATH=$PATH:/workdir/onnx-mlir/build/Debug/bin/:/workdir/onnx-mlir/build/Debug/lib:/workdir/llvm-project/build/bin
