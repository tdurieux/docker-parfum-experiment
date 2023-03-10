FROM ubuntu:18.04
WORKDIR /home/CoSA

RUN apt-get update && apt-get install --no-install-recommends -y python3-pip libpcre* wget unzip build-essential python3 automake libgmp-dev curl nano python3-dev libboost-dev default-jdk libclang-dev llvm llvm-dev lbzip2 libncurses5-dev git libtool iverilog libmpfr-dev libmpc-dev && rm -rf /var/lib/apt/lists/*;

RUN wget https://github.com/pysmt/pysmt/archive/master.zip
RUN unzip master.zip
RUN rm master.zip
RUN mv pysmt-master pysmt
RUN cd pysmt && pip3 install --no-cache-dir -e . && pysmt-install --msat --confirm-agreement --install-path solvers --bindings-path bindings
ENV PYTHONPATH="/home/CoSA/pysmt/bindings:${PYTHONPATH}"
ENV LD_LIBRARY_PATH="/home/CoSA/pysmt/bindings:${LD_LIBRARY_PATH}"

RUN wget https://github.com/leonardt/pycoreir/archive/master.zip
RUN unzip master.zip
RUN rm master.zip
RUN mv pycoreir-master pycoreir
RUN cd pycoreir && sed -i -e 's/KeyError(f"key={key} not found")/Error("key={key} not found".format(key=key))/g' coreir/type.py
RUN cd pycoreir && sed -i -e 's/KeyError(f"key={key} not in params={self.params.keys()}")/KeyError("key={key} not in params={params_keys}".format(key=key, params_keys=self.params.keys()))/g' coreir/generator.py
RUN cd pycoreir && sed -i -e 's/ValueError(f"Arg(name={key}, value={value}) does not match expected type {self.params\[key\].kind}")/ValueError("Arg(name={key}, value={value}) does not match expected type {params_kind}".format(key=key, value=value, params_kind=self.params\[key\].kind))/g' coreir/generator.py
RUN cd pycoreir && sed -i -e 's/f"{self.module.name}.{self.name}"/"{module_name}.{self_name}".format(module_name=self.module.name, name=self.name)/g' coreir/wireable.py
RUN cd pycoreir && sed -i -e 's/f"Cannot select path {field}"/"Cannot select path {field}".format(field=field)/g' coreir/module.py
RUN cd pycoreir && pip3 install --no-cache-dir -e .

RUN wget https://github.com/cristian-mattarei/CoSA/archive/master.zip
RUN unzip master.zip
RUN rm master.zip
RUN mv CoSA-master CoSA
RUN cd CoSA && pip3 install --no-cache-dir -e .
