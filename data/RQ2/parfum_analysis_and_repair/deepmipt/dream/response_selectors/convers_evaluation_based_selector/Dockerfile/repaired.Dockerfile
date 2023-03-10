FROM python:3.7.4

WORKDIR /src

ARG TAG_BASED_SELECTION
ENV TAG_BASED_SELECTION ${TAG_BASED_SELECTION}
ARG PRIORITIZE_WITH_SAME_TOPIC_ENTITY
ENV PRIORITIZE_WITH_SAME_TOPIC_ENTITY ${PRIORITIZE_WITH_SAME_TOPIC_ENTITY}
ARG PRIORITIZE_NO_DIALOG_BREAKDOWN
ENV PRIORITIZE_NO_DIALOG_BREAKDOWN ${PRIORITIZE_NO_DIALOG_BREAKDOWN}
ARG PRIORITIZE_WITH_REQUIRED_ACT
ENV PRIORITIZE_WITH_REQUIRED_ACT ${PRIORITIZE_WITH_REQUIRED_ACT}
ARG IGNORE_DISLIKED_SKILLS
ENV IGNORE_DISLIKED_SKILLS ${IGNORE_DISLIKED_SKILLS}
ARG GREETING_FIRST
ENV GREETING_FIRST ${GREETING_FIRST}
ARG RESTRICTION_FOR_SENSITIVE_CASE
ENV RESTRICTION_FOR_SENSITIVE_CASE ${RESTRICTION_FOR_SENSITIVE_CASE}
ARG PRIORITIZE_PROMTS_WHEN_NO_SCRIPTS
ENV PRIORITIZE_PROMTS_WHEN_NO_SCRIPTS ${PRIORITIZE_PROMTS_WHEN_NO_SCRIPTS}
ARG ADD_ACKNOWLEDGMENTS_IF_POSSIBLE
ENV ADD_ACKNOWLEDGMENTS_IF_POSSIBLE ${ADD_ACKNOWLEDGMENTS_IF_POSSIBLE}
ARG PROMPT_PROBA
ENV PROMPT_PROBA ${PROMPT_PROBA}
ARG ACKNOWLEDGEMENT_PROBA
ENV ACKNOWLEDGEMENT_PROBA ${ACKNOWLEDGEMENT_PROBA}
ARG CALL_BY_NAME_PROBABILITY
ENV CALL_BY_NAME_PROBABILITY ${CALL_BY_NAME_PROBABILITY}
ARG PRIORITIZE_SCRIPTED_SKILLS
ENV PRIORITIZE_SCRIPTED_SKILLS ${PRIORITIZE_SCRIPTED_SKILLS}

COPY ./response_selectors/convers_evaluation_based_selector/requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
RUN python -c "import nltk; nltk.download('punkt')"

ARG LANGUAGE=EN
ENV LANGUAGE ${LANGUAGE}

COPY ./response_selectors/convers_evaluation_based_selector/ ./
COPY ./common/ ./common/

CMD gunicorn --workers=2 server:app
