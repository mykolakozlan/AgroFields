FROM python:3.11-slim

WORKDIR /app

# Встановлюємо залежності та Postgres client
RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
    && pip install psycopg2-binary

COPY ./app /app/app
COPY ./migrations /app/migrations
COPY ./alembic.ini /app/alembic.ini
COPY ./entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 8000

CMD ["/entrypoint.sh"]
