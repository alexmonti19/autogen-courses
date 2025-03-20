## ------------------------------- Base-system Stage ------------------------------ ## 
FROM --platform=$BUILDPLATFORM python:3.13-slim-bookworm AS base
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# required packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        python3-setuptools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# virtualenv via uv
COPY pyproject.toml .
RUN uv sync

## ------------------------------- Development Stage ------------------------------ ## 

FROM --platform=$BUILDPLATFORM python:3.13-slim-bookworm AS development
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ARG USERNAME=user
RUN adduser $USERNAME 

# get venv from base stage
COPY --from=base --chown=$USERNAME .venv /.venv

# set uv-specific environment vars to make uv always point to the created venv
ENV VIRTUAL_ENV="/.venv"
ENV UV_PROJECT_ENVIRONMENT="/.venv"

# set path to use the created venv by defalt 
ENV PATH="/.venv/bin:$PATH"

# source folder
WORKDIR /workspace
COPY . ./ --chown=$USERNAME

USER $USERNAME