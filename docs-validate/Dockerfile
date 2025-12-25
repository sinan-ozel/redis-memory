FROM python:3.11-slim

WORKDIR /workspace

# Copy pyproject.toml and source code needed for dynamic version
COPY pyproject.toml /tmp/pyproject.toml
COPY src/ /tmp/src/

RUN pip install --upgrade pip && \
    cd /tmp && \
    pip install .[docs] && \
    rm -rf /tmp/*

# Files will be mounted at /workspace
CMD ["./docs-validate/validate-docs.sh"]
