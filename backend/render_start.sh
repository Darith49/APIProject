#!/bin/bash
set -e

echo "Running migrations..."
python manage.py migrate --noinput

echo "Creating superuser if needed..."
python manage.py shell -c "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.filter(username='admin').exists() or User.objects.create_superuser('admin', 'admin@gmail.com', '123')"

echo "Collecting static files..."
python manage.py collectstatic --noinput

echo "Starting server..."
gunicorn saveur.wsgi:application --bind 0.0.0.0:$PORT
