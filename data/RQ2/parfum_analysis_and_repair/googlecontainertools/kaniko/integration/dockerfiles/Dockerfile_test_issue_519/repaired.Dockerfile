FROM alpine as base_stage
RUN echo base_stage
RUN touch meow.txt

FROM base_stage as BUG_stage
RUN echo BUG_stage
RUN touch purr.txt


FROM BUG_stage as final_stage
RUN echo final_stage
RUN touch mew.txt