FROM node:20-bookworm-slim

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends libsqlite3-dev g++ build-essential \
    python3 python3-pip python3-venv \
    curl default-jre graphviz fonts-dejavu fontconfig \
    git && \
    rm -rf /var/lib/apt/lists/*

CMD ["yarn", "dev"]
