FROM marcskovmadsen/awesome-panel:latest

WORKDIR /app

RUN pip install --no-cache-dir pylint2junit
RUN ls test_results; exit 0
RUN mkdir -p test_results; exit 0

RUN pylint --rcfile=.pylintrc --output-format=pylint2junit.JunitReporter docs tasks awesome_panel tests 2>&1 > test_results/pylint-results.xml;exit 0

RUN rm -rf .mypy_cache/; exit 0
RUN mypy --config-file=mypy.ini --junit-xml test_results/mypy-results.xml docs tasks awesome_panel tests; exit 0

RUN pytest tests -m "not functionaltest and not integrationtest" --doctest-modules --junitxml=test_results/test-results.xml; exit 0

# Remove empty test_results files.
# Pylint produces empty files if no issues identified
# This causes problems when publishing test results
# Thus we delete empty files here.
RUN touch test_results/dummy && find test_results -size 0 -print0 |xargs -0 rm --
RUN ls test_results

ENTRYPOINT ["/bin/bash"]

