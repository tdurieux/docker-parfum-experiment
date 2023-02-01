FROM rpy2/rpy2:latest

RUN apt-get update -y

RUN apt-get install --no-install-recommends -y vim nano && rm -rf /var/lib/apt/lists/*;

RUN apt-get remove curl && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

RUN apt-get remove libssl-dev && apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libgtk2.0-dev xvfb xauth xfonts-base libcairo2-dev libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*; # libxaw xlib

RUN apt-get install --no-install-recommends -y libx11-dev openssl libxt-dev && rm -rf /var/lib/apt/lists/*; #libxaw xlib

RUN pip install --no-cache-dir pip==19.0.3

RUN pip install --no-cache-dir rpy2==2.9.4

RUN pip install --no-cache-dir numpy kneed Cython pathos nevergrad

RUN pip install --no-cache-dir umap-learn >=0.3.7 plotly >=3.4.2 fancyimpute >=0.4.2 pandas >=0.23.4 scikit-learn >=0.20.1

RUN pip install --no-cache-dir shap matplotlib seaborn mlxtend click==6.7

RUN pip install --no-cache-dir pymethylprocess==0.1.3 --no-deps

RUN pymethyl-install_r_dependencies

RUN mkdir ./pymethyl
WORKDIR /pymethyl

RUN pip install --no-cache-dir git+https://github.com/bodono/scs-python.git@bb45c69ce57b1fbb5ab23e02b30549a7e0b801e3

RUN pip install --no-cache-dir git+https://github.com/jlevy44/hypopt.git@af59fbed732f5377cda73fdf42f3d4981c2be3ce

RUN pip install --no-cache-dir pymethylprocess==0.1.3 --no-deps

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
