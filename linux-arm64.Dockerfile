FROM hotio/base@sha256:16e7a6ff1afb079c94230d0994892eb40721f9673c4adb914d3cc26f97eda18f

ARG DEBIAN_FRONTEND="noninteractive"

ENV TAUTULLI_DOCKER="True"

EXPOSE 8181

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        python-pkg-resources python-pycryptodome \
        python-pip python-setuptools build-essential python-all-dev libffi-dev && \
    pip install --no-cache-dir --upgrade plexapi pyopenssl && \
# clean up
    apt purge -y python-pip python-setuptools build-essential python-all-dev libffi-dev && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# https://github.com/Tautulli/Tautulli/releases
ARG TAUTULLI_VERSION=2.1.41

# install app
RUN curl -fsSL "https://github.com/Tautulli/Tautulli/archive/v${TAUTULLI_VERSION}.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}" && \
    echo "None" > "${APP_DIR}/version.txt" && \
    echo "None" > "${APP_DIR}/version.lock" && \
    echo "v${TAUTULLI_VERSION}" > "${APP_DIR}/release.lock"

COPY root/ /
