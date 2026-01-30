#!/bin/sh
set -e

DB_HOST=${DB_HOST:-postgres}
DB_PORT=${DB_PORT:-5432}
DB_USER=${POSTGRES_USER:-postgres}
DB_PASSWORD=${POSTGRES_PASSWORD:-postgres}
DB_NAME=${POSTGRES_DB:-postgres}
APP_PORT=${APP_PORT:-8000}

export PYTHONPATH=/app:$PYTHONPATH

wait_for_db() {
  echo "Waiting for database at $DB_HOST:$DB_PORT..."
  until pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" > /dev/null 2>&1; do
    echo "Database is unavailable, sleeping 2s..."
    sleep 2
  done
  echo "Database is up!"
}

wait_for_db

echo "Applying database migrations..."
alembic -c /app/alembic.ini upgrade head

echo "Starting FastAPI..."
exec uvicorn app.main:app --host 0.0.0.0 --port $APP_PORT --reload
