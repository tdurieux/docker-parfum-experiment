# intermediate image for dependencies and user "rxn4chemistry" setup
FROM rxn4chemistry/rxn4chemistry-base:main
RUN pip install --no-cache-dir notebook==5.* rxn4chemistry>=1.0.0
RUN adduser --disabled-password --gecos '' rxn4chemistry
ENV HOME /home/rxn4chemistry
COPY examples/ ${HOME}/examples/
RUN chown -R rxn4chemistry:rxn4chemistry ${HOME}
# run jupyter