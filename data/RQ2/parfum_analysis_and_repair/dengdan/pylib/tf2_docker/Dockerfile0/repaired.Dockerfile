FROM dengdan/tensorflow-gpu:tf2.0
RUN apt-get update && apt-get install --no-install-recommends -y graphviz && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple pydot
