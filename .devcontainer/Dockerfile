FROM mcr.microsoft.com/devcontainers/base:2.2.5-trixie@sha256:71b6fe7c4e07ec747a94a72b2a17f2f8c286eaa7b1c59862888df764efb8b6c6

# cspell:disable
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
    && mkdir -p /commandhistory \
    && touch /commandhistory/.bash_history \
    && chown -R vscode /commandhistory \
    && echo "$SNIPPET" >> /home/vscode/.bashrc
# cspell:enable

ARG NODE_VERSION=26.13.0
ARG COREPACK_VERSION=0.36.0
ARG YQ_VERSION=4.53.6

# cspell:ignore dpkg esac SHASUMS
# cspell:disable-next-line
RUN arch="$(dpkg --print-architecture)" \
    # Install Node directly: the Node Feature installs Yarn/pnpm commands that
    # conflict with Corepack's shims. Corepack selects the project's pinned Yarn.
    && case "$arch" in \
        amd64) node_arch=x64 ;; \
        arm64) node_arch=arm64 ;; \
        *) echo "Unsupported Node.js architecture: $arch" >&2; exit 1 ;; \
    esac \
    && node_archive="node-v${NODE_VERSION}-linux-${node_arch}.tar.xz" \
    && node_base_url="https://nodejs.org/dist/v${NODE_VERSION}" \
    && cd /tmp \
    && curl -fsSLO "${node_base_url}/${node_archive}" \
    && curl -fsSLO "${node_base_url}/SHASUMS256.txt" \
    && grep "  ${node_archive}\$" SHASUMS256.txt | sha256sum -c - \
    && tar -xJf "${node_archive}" -C /usr/local --strip-components=1 --no-same-owner \
    && rm "${node_archive}" SHASUMS256.txt \
    && npm install -g "corepack@${COREPACK_VERSION}" \
    && corepack enable \
    # Download the pinned yq binary and verify its SHA-256 checksum.
    && yq_binary="yq_linux_${arch}" \
    && yq_package="${yq_binary}.tar.gz" \
    && yq_base_url="https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}" \
    && cd /tmp \
    && curl -fsSLO "${yq_base_url}/${yq_package}" \
    && curl -fsSLO "${yq_base_url}/checksums" \
    && awk -v package="${yq_package}" '$1 == package { print $19 "  " $1 }' checksums | sha256sum -c - \
    && tar -xzf "${yq_package}" \
    && install -m 0755 "${yq_binary}" /usr/local/bin/yq \
    && rm -rf "${yq_package}" "${yq_binary}" checksums \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        # Additional utilities for AI agents and development.
        jq \
        ripgrep \
        # Debian package build (make deb).
        build-essential \
        debhelper \
    && rm -rf /var/lib/apt/lists/* \
    && yq --version \
    && node --version \
    && corepack --version
