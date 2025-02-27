FROM base:dev

# set argument defaults
ARG USER=vlabs
ARG GROUP=users

# Switch to root to install OS packages
USER root:root

# update repositories, install packages, and then clean up
RUN tdnf update -y && \
    # grab what we can via standard packages
    tdnf install -y \
        python3 \
        python3-pip  && \
    # clean up
    tdnf clean all

# install mkdocs, mkdocs-material, and desired plugins
COPY ./requirements.txt .
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir -r ./requirements.txt

# switch back to non-root user
USER ${USER}:${GROUP}

# expose MkDocs development server port
EXPOSE 8000

# set entrypoint to bash or mkdocs
ENTRYPOINT ["mkdocs"]

# start development server by default
CMD ["serve", "--dev-addr=0.0.0.0:8000"]

#############################################################################
# vim: ft=unix sync=dockerfile ts=4 sw=4 et tw=78:
