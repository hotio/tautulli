FROM hotio/base

ARG DEBIAN_FRONTEND="noninteractive"

ENV APP="Tautulli"
EXPOSE 8181
HEALTHCHECK --interval=60s CMD curl -fsSL http://localhost:8181 || exit 1

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        python-pkg-resources python-pycryptodome && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# install app
# https://github.com/Tautulli/Tautulli/releases
RUN curl -fsSL "https://github.com/Tautulli/Tautulli/archive/v2.1.33.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
