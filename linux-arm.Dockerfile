FROM hotio/base@sha256:5193797b5db238405f64036a60a0f59d425050bc10cfc708eccd91cf5f38c18a

ARG DEBIAN_FRONTEND="noninteractive"

ENV TAUTULLI_DOCKER="True"

EXPOSE 8181

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        python python-pkg-resources libxml2 libxslt1.1 \
        python-pip python-setuptools build-essential python-all-dev libffi-dev libssl-dev libxml2-dev libxslt1-dev && \
    pip install --no-cache-dir --upgrade plexapi pyopenssl pycryptodomex lxml && \
# clean up
    apt purge -y python-pip python-setuptools build-essential python-all-dev libffi-dev libssl-dev libxml2-dev libxslt1-dev && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# https://github.com/Tautulli/Tautulli/releases
ARG TAUTULLI_VERSION=2.1.43

# install app
RUN curl -fsSL "https://github.com/Tautulli/Tautulli/archive/v${TAUTULLI_VERSION}.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}" && \
    echo "None" > "${APP_DIR}/version.txt" && \
    echo "None" > "${APP_DIR}/version.lock" && \
    echo "v${TAUTULLI_VERSION}" > "${APP_DIR}/release.lock"

COPY root/ /
