FROM dustynv/pytorch:2.7-r36.4.0-cu128-24.04

# Use system's network during build
ARG DEBIAN_FRONTEND=noninteractive

# Set pip index URL as environment variable (works for build AND runtime)
ENV PIP_INDEX_URL=https://pypi.org/simple

# Update and install system dependencies first
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-opencv \
    && rm -rf /var/lib/apt/lists/*

# Remove the problematic custom PyPI indexes
RUN pip3 config unset global.index-url || true && \
    pip3 config unset global.extra-index-url || true

# Install Python packages
RUN pip3 install --no-cache-dir ultralytics omegaconf

# Create GPU warmup script
RUN echo '#!/bin/bash' > /usr/local/bin/startup.sh && \
    echo 'python3 -c "import torch; dummy=torch.zeros(1).cuda(); torch.cuda.synchronize(); del dummy; torch.cuda.empty_cache(); print(\"GPU ready\")" 2>/dev/null || echo "GPU warmup skipped"' >> /usr/local/bin/startup.sh && \
    echo 'exec "$@"' >> /usr/local/bin/startup.sh && \
    chmod +x /usr/local/bin/startup.sh

WORKDIR /workspace

ENTRYPOINT ["/usr/local/bin/startup.sh"]
CMD ["/bin/bash"]
