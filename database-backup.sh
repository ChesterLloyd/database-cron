#!/bin/bash

# Get env variable
DB_HOST=${DB_HOST}
DB_NAME=${DB_NAME}
DB_USERNAME=${DB_USERNAME}
DB_PASSWORD=${DB_PASSWORD}
SENTRY_CRONS=${SENTRY_CRONS}
BACKUP_DIR="/mnt/backup"

if [ -n "${SENTRY_CRONS}" ]; then
  # 🟡 Notify Sentry the the job is running
  curl "${SENTRY_CRONS}&status=in_progress"
fi

# echo an error, inform Sentry and exit
errorAndExit() {
  echo "Exiting job: " $1

  if [ -n "${SENTRY_CRONS}" ]; then
    # 🔴 Notify Sentry that the job has failed
    curl "${SENTRY_CRONS}&status=error"
  fi

  exit 1
}

# Check env variables
if [[ ${DB_HOST} == "" ]]; then
  errorAndExit "Missing DB_HOST env variable"
fi
if [[ ${DB_NAME} == "" ]]; then
  errorAndExit "Missing DB_NAME env variable"
fi
if [[ ${DB_USERNAME} == "" ]]; then
  errorAndExit "Missing DB_USERNAME env variable"
fi
if [[ ${DB_PASSWORD} == "" ]]; then
  errorAndExit "Missing DB_PASSWORD env variable"
fi

# Dump the database
mysqldump happens

# 🟢 Notify Sentry that the job has completed successfully
curl "${SENTRY_CRONS}&status=ok"
