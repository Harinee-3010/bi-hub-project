# Step 1: Start from an official Python base image
# We use 3.10 to match your local environment. 'slim' is a lightweight version.
FROM python:3.10-slim

# Step 2: Set environment variables
# This prevents Python from buffering output, which helps with logging.
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Step 3: Set the working directory inside the container
# All our commands will run from here
WORKDIR /app

# Step 4: Install system dependencies
# We install 'libpq-dev' and 'build-essential' which are needed by 
# 'psycopg2' (our PostgreSQL connector) to build correctly.
RUN apt-get update \
    && apt-get -y install libpq-dev build-essential \
    && rm -rf /var/lib/apt/lists/*

# Step 5: Copy and install Python requirements
# We copy *only* the requirements file first, to take advantage of Docker's caching.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Step 6: Copy the rest of your project code into the container
# The '.' means "copy everything from the current folder (on your laptop)
# into the '/app' folder (inside the container)."
COPY . .

# Note: We don't need an 'EXPOSE' or 'CMD' command.
# 'gunicorn' will be run by Render from a separate build script,
# and it will automatically bind to the correct port.