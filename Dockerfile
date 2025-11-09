# Step 1: Start from the official Python 3.10 image
FROM python:3.10-slim

# Step 2: Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Step 3: Set the working directory
WORKDIR /app

# Step 4: Install system dependencies for PostgreSQL
RUN apt-get update \
    && apt-get -y install libpq-dev build-essential \
    && rm -rf /var/lib/apt/lists/*

# Step 5: Copy and install Python requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Step 6: Copy your project code
COPY . .

# Step 7: Run collectstatic
# This finds all your CSS/JS and puts them in one folder
RUN python manage.py collectstatic --noinput

# Step 8: Expose the port
EXPOSE 8000

# Step 9: Set the default command to start the server
CMD ["gunicorn", "core.wsgi"]