#!/bin/bash
set -e

echo "Checking migration status..."
python manage.py showmigrations api || true

echo "Faking migration 0004 if needed..."
python manage.py migrate --fake api 0004_fix_order_payment_receipt || true

echo "Running all migrations..."
python manage.py migrate --noinput

echo "Creating superuser if needed..."
python manage.py shell -c "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.filter(username='admin').exists() or User.objects.create_superuser('admin', 'admin@saveur.com', 'YourPassword123')"

echo "Collecting static files..."
python manage.py collectstatic --noinput

echo "Starting server..."
gunicorn saveur.wsgi:application --bind 0.0.0.0:$PORT
