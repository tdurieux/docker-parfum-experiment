ARG FROM_IMAGE=pash
FROM $FROM_IMAGE
RUN git clone https://github.com/mgree/smoosh.git /smoosh
RUN git -C /smoosh apply /pash/evaluation/correctness/smoosh_problematic_tests.patch