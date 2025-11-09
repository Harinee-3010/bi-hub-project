#!/usr/bin/env bash
# This script tells Render what to do when it deploys your app.

# 1. Exit immediately if a command fails
set -o errexit

# 2. Collect all static files (like CSS) into one folder
#    '--noinput' just confirms "yes" to any questions
python manage.py collectstatic --noinput

# 3. Apply any new database changes
python manage.py migrate