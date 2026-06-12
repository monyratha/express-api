# Use Ubuntu as the base OS for the container.
FROM ubuntu:24.04

# Build-time settings for apt and the SSH account.
ARG DEBIAN_FRONTEND=noninteractive
ARG SSH_USER=root
ARG SSH_PASSWORD=123456

# Runtime environment for the Express app.
ENV NODE_ENV=production
ENV PORT=3000

# Install Node.js and OpenSSH, then configure password SSH login.
# Root SSH is only enabled when SSH_USER=root for local development.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        nodejs \
        npm \
        openssh-server \
        sudo \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /run/sshd \
    && if ! id -u "${SSH_USER}" >/dev/null 2>&1; then useradd -m -s /bin/bash "${SSH_USER}"; fi \
    && echo "${SSH_USER}:${SSH_PASSWORD}" | chpasswd \
    && usermod -aG sudo "${SSH_USER}" \
    && sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && if [ "${SSH_USER}" = "root" ]; then \
        sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config; \
    else \
        sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config; \
    fi \
    && sed -i 's/^#\?UsePAM .*/UsePAM no/' /etc/ssh/sshd_config

# Store the application source under /app.
WORKDIR /app

# Install production dependencies first for better Docker layer caching.
COPY package*.json ./
RUN npm ci --omit=dev

# Copy the Express app source code.
COPY src ./src

# Port 22 is for SSH; port 3000 is for the Express API.
EXPOSE 22 3000

# Start SSH in the background, then run the API as the main process.
CMD ["/bin/sh", "-c", "/usr/sbin/sshd && exec npm start"]
