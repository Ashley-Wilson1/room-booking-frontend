# syntax=docker/dockerfile:1

ARG NODE_VERSION=14.17.5

################################################################################
# Use node image for base image for all stages.
FROM node:${NODE_VERSION}-alpine as base

# Set working directory for all build stages.
WORKDIR /usr/src/app

################################################################################
# Create a stage for installing dependencies.
FROM base as deps

# Install dependencies (including dev dependencies for development).
RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=package-lock.json,target=package-lock.json \
    --mount=type=cache,target=/root/.npm \
    npm install

################################################################################
# Create a stage to run the application.
FROM deps as final

# Set the environment variable for development.
ENV NODE_ENV development

# Expose the port the app will run on.
EXPOSE 3000

# Copy the source code into the container.
COPY . .

# Run the application with npm start.
CMD ["npm", "start"]
