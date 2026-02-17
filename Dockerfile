FROM dustynv/pytorch:2.7-r36.4.0-cu128-24.04

# Use system's network during build
ARG DEBIAN_FRONTEND=noninteractive

# Update and install system dependencies first
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-opencv \
    && rm -rf /var/lib/apt/lists/*

# Remove the problematic custom PyPI indexes
RUN pip3 config unset global.index-url || true && \
    pip3 config unset global.extra-index-url || true && \
    pip3 config set global.index-url https://pypi.org/simple

# Install Python packages
RUN pip3 install --no-cache-dir --index-url https://pypi.org/simple ultralytics omegaconf

WORKDIR /workspace

CMD ["/bin/bash"]
