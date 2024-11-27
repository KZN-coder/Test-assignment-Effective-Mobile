# **Тестовое задание**
## Effective Mobile

Этот проект включает Bash-скрипт и юнит-файл systemd для мониторинга процесса test в среде Linux. Скрипт проверяет наличие процесса каждую минуту, отправляет HTTP-запрос на сервер мониторинга, если процесс запущен, и записывает события в лог-файл.

## Установка

Файл **test_process.sh** и **monitor_test.sh** сделать исполняемыми

```sh
chmod +x /usr/local/bin/monitor_test.sh
chmod +x /usr/local/bin/test_process.sh
```

Файлы **monitor_test.service** и **monitor_test.timer** переместить в директорию /etc/systemd/system/
Далее:
```sh
systemctl daemon-reload
systemctl enable monitor_test.timer
systemctl start monitor_test.timer
```

После этих действий можем запускать наш тестовый процесс и проверять логи:
```sh
./test_process.sh &
tail -f /var/log/monitoring.log
```
