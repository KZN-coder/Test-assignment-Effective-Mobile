#!/bin/bash

LOG_FILE="/var/log/monitoring.log"
MONITORING_URL="https://test.com/monitoring/test/api"
PROCESS_NAME="test_process.sh"
LAST_PID_FILE="/tmp/last_pid.txt"

# Создание лог-файла, если он не существует
if [ ! -f $LOG_FILE ]; then
    touch $LOG_FILE
    chmod 644 $LOG_FILE
fi

# Функция для записи в лог
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

# Проверка наличия процесса
if pgrep -f $PROCESS_NAME > /dev/null; then
    CURRENT_PID=$(pgrep -f $PROCESS_NAME)

    # Проверка, был ли процесс перезапущен
    if [ -f $LAST_PID_FILE ]; then
        LAST_PID=$(cat $LAST_PID_FILE)
        if [ "$CURRENT_PID" != "$LAST_PID" ]; then
            log_message "Process $PROCESS_NAME was restarted. Old PID: $LAST_PID, New PID: $CURRENT_PID"
        fi
    fi

    # Сохранение текущего PID
    echo $CURRENT_PID > $LAST_PID_FILE

    # Отправка HTTP-запроса
    if curl -s -o /dev/null -w "%{http_code}" $MONITORING_URL | grep -q "200"; then
        log_message "Successfully pinged monitoring server."
    else
        log_message "Failed to ping monitoring server."
    fi
else
    log_message "Process $PROCESS_NAME is not running."
fi
