FROM photon:5.0

# set argument defaults
ARG USER=vlabs
# ARG USER_ID=1000
ARG GROUP=users
# ARG GROUP_ID=100
#ARG LABEL_PREFIX=net.lab

# # add metadata via labels
# LABEL ${LABEL_PREFIX}.version="0.0.1"
# LABEL ${LABEL_PREFIX}.git.repo="git@github.com:grumpdumpty/theworks.git"
# LABEL ${LABEL_PREFIX}.git.commit="DEADBEEF"
# LABEL ${LABEL_PREFIX}.maintainer.name="Richard Croft"
# LABEL ${LABEL_PREFIX}.maintainer.email="rcroft@vmware.com"
# LABEL ${LABEL_PREFIX}.maintainer.url="https://github.com/grumpdumpty"
# LABEL ${LABEL_PREFIX}.released="9999-99-99"
# LABEL ${LABEL_PREFIX}.based-on="photon:5.0"
# LABEL ${LABEL_PREFIX}.project="theworks"

# # update repositories
# RUN tdnf update -y && \
#     tdnf install -y glibc-i18n && \
#     tdnf clean all && \
#     locale-gen.sh

# ENV LOCALE=en_US.utf-8
# ENV LC_ALL=en_US.utf-8

# update repositories, install packages, and then clean up
RUN tdnf update -y && \
    # grab what we can via standard packages
    tdnf install -y \
        bash \
        ca-certificates \
        coreutils \
        curl \
        diffutils \
        gawk \
        git \
        htop \
        jq \
        mc \
        ncurses \
        python3 \
        python3-pip \
        shadow \
        tar \
        tmux \
        vim && \
    # add user/group, specifying ids
    # groupadd -g ${GROUP_ID} ${GROUP} && \
    # useradd -u ${USER_ID} -g ${GROUP} -m ${USER} && \
    # add user/group, using names
    useradd -g ${GROUP} -m ${USER} && \
    # set home dir permissions
    chown -R ${USER}:${GROUP} /home/${USER} && \
    # add /workspace and give user permissions
    mkdir -p /workspace && \
    chown -R ${USER}:${GROUP} /workspace && \
    # set git config
    git config --system --add init.defaultBranch "main" && \
    git config --system --add safe.directory "/workspace"

# install mkdocs, mkdocs-material, and desired plugins
COPY ./requirements.txt .
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir -r ./requirements.txt

    # harden and remove unecessary packages
RUN chown -R root:root /usr/local/bin/ && \
chown root:root /var/log && \
chmod 0640 /var/log && \
chown root:root /usr/lib/ && \
chmod 755 /usr/lib/

# clean up
RUN tdnf erase -y unzip shadow && \
tdnf clean all

# set user
USER ${USER}

# set working directory
WORKDIR /workspace

# expose MkDocs development server port
EXPOSE 8000

# set entrypoint to bash or mkdocs
ENTRYPOINT ["mkdocs"]

# start development server by default
CMD ["serve", "--dev-addr=0.0.0.0:8000"]

#############################################################################
# vim: ft=unix sync=dockerfile ts=4 sw=4 et tw=78:
