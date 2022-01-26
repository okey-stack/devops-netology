# Домашнее задание к занятию "10.03. Grafana"

## Задание повышенной сложности

**В части задания 1** не используйте директорию [help](./help) для сборки проекта, самостоятельно разверните grafana, где в 
роли источника данных будет выступать prometheus, а сборщиком данных node-exporter:
- grafana
- prometheus-server
- prometheus node-exporter

За дополнительными материалами, вы можете обратиться в официальную документацию grafana и prometheus.

В решении к домашнему заданию приведите также все конфигурации/скрипты/манифесты, которые вы 
использовали в процессе решения задания.

**В части задания 3** вы должны самостоятельно завести удобный для вас канал нотификации, например Telegram или Email
и отправить туда тестовые события.

В решении приведите скриншоты тестовых событий из каналов нотификаций.

## Обязательные задания

### Задание 1
Используя директорию [help](./help) внутри данного домашнего задания - запустите связку prometheus-grafana.

Зайдите в веб-интерфейс графана, используя авторизационные данные, указанные в манифесте docker-compose.

Подключите поднятый вами prometheus как источник данных.

Решение домашнего задания - скриншот веб-интерфейса grafana со списком подключенных Datasource.  
![Prometheus](img/prometh_ds.png)  
## Задание 2
Изучите самостоятельно ресурсы:
- [promql-for-humans](https://timber.io/blog/promql-for-humans/#cpu-usage-by-instance)
- [understanding prometheus cpu metrics](https://www.robustperception.io/understanding-machine-cpu-usage)

Создайте Dashboard и в ней создайте следующие Panels:
- Утилизация CPU для nodeexporter (в процентах, 100-idle)  
    100 * (1 - avg by(instance)(irate(node_cpu_seconds_total{cpu="0", instance="nodeexporter:9100", job="nodeexporter", mode="idle"}[1m])))
- CPULA 1/5/15  
    node_load1{instance="nodeexporter:9100", job="nodeexporter"}
    node_load5{instance="nodeexporter:9100", job="nodeexporter"}
    node_load15{instance="nodeexporter:9100", job="nodeexporter"}
- Количество свободной оперативной памяти  
    node_memory_MemFree_bytes{instance="nodeexporter:9100", job="nodeexporter"}
- Количество места на файловой системе  
    node_filesystem_avail_bytes{device="/dev/mapper/vg_core-home", fstype="ext4", instance="nodeexporter:9100", job="nodeexporter", mountpoint="/home"}  
Для решения данного ДЗ приведите promql запросы для выдачи этих метрик, а также скриншот получившейся Dashboard.
    ![dashboard](img/dashboard.png)  
## Задание 3
Создайте для каждой Dashboard подходящее правило alert (можно обратиться к первой лекции в блоке "Мониторинг").  
    ![dashboard](img/sum_dashboard.png)  
Для решения ДЗ - приведите скриншот вашей итоговой Dashboard.

## Задание 4
Сохраните ваш Dashboard.

Для этого перейдите в настройки Dashboard, выберите в боковом меню "JSON MODEL".

Далее скопируйте отображаемое json-содержимое в отдельный файл и сохраните его.

В решении задания - приведите листинг этого файла.  

    [dashboard](dashboard.json)

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
