FROM mozilla/oidc-testprovider:oidc_testprovider-v0.9.4

# Modify redirect_urls specified in "fixtures.json" to fit our needs.
COPY ./docker/config/oidcprovider-fixtures.json /code/fixtures.json