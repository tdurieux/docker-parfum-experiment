FROM itprojectsllc/install-odoo:10.0

USER root

# install dependencies
RUN pip install --no-cache-dir -U pip && \
    pip install --no-cache-dir -U requests && \
    pip install --no-cache-dir 'requests[security]' && \
    pip install --no-cache-dir pyTelegramBotAPI && \
    pip install --no-cache-dir emoji && \
    apt-get install -y --no-install-recommends libffi-dev && \
    pip install --no-cache-dir pygal && \
    pip install --no-cache-dir "cairosvg<2.0.0" tinycss cssselect && \
    echo "telegram dependencies are installed" && rm -rf /var/lib/apt/lists/*;

# add telegram to server-wide modules
RUN sed -i -e "s/^\(server_wide_modules.*\)/\1,telegram/" $OPENERP_SERVER

USER odoo
