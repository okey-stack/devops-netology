# Домашнее задание к занятию "10.02. Системы мониторинга"

## Обязательные задания

1. Опишите основные плюсы и минусы pull и push систем мониторинга.
   1. Push
      1. Есть возможность перейти на отправку данных по UDP, что увеличит производительность сбора данных
      2. Более гибкая настройка отпарвки данных - объем и частота
      3. Упрощение репликации данных = каждый клиент может слать данные в несколько ендпоинтов
   2. Pull
      1. Проще контролировать подлинность данных т.к. сервер является ициниатором и знает кто ему отдает их
      2. Проще контроливароть и отладивать получение данных с агентов
      3. Можно настроить единый сервер где будет насроен TLS для всех агентов для безопасного обмена данными
2. Какие из ниже перечисленных систем относятся к push модели, а какие к pull? А может есть гибридные?

    - Prometheus - pull
    - TICK - push
    - Zabbix - push
    - VictoriaMetrics - 
    - Nagios

3. Склонируйте себе [репозиторий](https://github.com/influxdata/sandbox/tree/master) и запустите TICK-стэк, 
используя технологии docker и docker-compose.

В виде решения на это упражнение приведите выводы команд с вашего компьютера (виртуальной машины):

    - curl http://localhost:8086/ping  
      < HTTP/1.1 204 No Content
      < Content-Type: application/json
      < Request-Id: 4c48c8e7-7ece-11ec-8045-0242ac120002
      < X-Influxdb-Build: OSS
      < X-Influxdb-Version: 1.8.10
      < X-Request-Id: 4c48c8e7-7ece-11ec-8045-0242ac120002
      < Date: Wed, 26 Jan 2022 17:35:04 GMT
    - curl http://localhost:8888  
      <!DOCTYPE html><html><head><meta http-equiv="Content-type" content="text/html; charset=utf-8"><title>Chronograf</title><link rel="icon shortcut" href="/favicon.fa749080.ico"><link rel="stylesheet" href="/src.3dbae016.css"></head><body> <div id="react-root" data-basepath=""></div> <script src="/src.fab22342.js"></script> </body></html>
    - curl http://localhost:9092/kapacitor/v1/ping  
      < HTTP/1.1 204 No Content
      < Content-Type: application/json; charset=utf-8
      < Request-Id: a1792791-7ece-11ec-8057-000000000000
      < X-Kapacitor-Version: 1.6.3
      < Date: Wed, 26 Jan 2022 17:37:27 GMT
      <

А также скриншот веб-интерфейса ПО chronograf (`http://localhost:8888`).  
    [screen](img/chronograf.png)   

P.S.: если при запуске некоторые контейнеры будут падать с ошибкой - проставьте им режим `Z`, например
`./data:/var/lib:Z`

1. Перейдите в веб-интерфейс Chronograf (`http://localhost:8888`) и откройте вкладку `Data explorer`.

    - Нажмите на кнопку `Add a query`
    - Изучите вывод интерфейса и выберите БД `telegraf.autogen`
    - В `measurments` выберите mem->host->telegraf_container_id , а в `fields` выберите used_percent. 
    Внизу появится график утилизации оперативной памяти в контейнере telegraf.
    - Вверху вы можете увидеть запрос, аналогичный SQL-синтаксису. 
    Поэкспериментируйте с запросом, попробуйте изменить группировку и интервал наблюдений.

Для выполнения задания приведите скриншот с отображением метрик утилизации места на диске 
(disk->host->telegraf_container_id) из веб-интерфейса.
    [disk](img/disk.png)  

5. Изучите список [telegraf inputs](https://github.com/influxdata/telegraf/tree/master/plugins/inputs). 
Добавьте в конфигурацию telegraf следующий плагин - [docker](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/docker):
```
[[inputs.docker]]
  endpoint = "unix:///var/run/docker.sock"
```

Дополнительно вам может потребоваться донастройка контейнера telegraf в `docker-compose.yml` дополнительного volume и 
режима privileged:
```
  telegraf:
    image: telegraf:1.4.0
    privileged: true
    volumes:
      - ./etc/telegraf.conf:/etc/telegraf/telegraf.conf:Z
      - /var/run/docker.sock:/var/run/docker.sock:Z
    links:
      - influxdb
    ports:
      - "8092:8092/udp"
      - "8094:8094"
      - "8125:8125/udp"
```

После настройке перезапустите telegraf, обновите веб интерфейс и приведите скриншотом список `measurments` в 
веб-интерфейсе базы telegraf.autogen . Там должны появиться метрики, связанные с docker.
  [docker](img/docker.png)
Факультативно можете изучить какие метрики собирает telegraf после выполнения данного задания.

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

В веб-интерфейсе откройте вкладку `Dashboards`. Попробуйте создать свой dashboard с отображением:

    - утилизации ЦПУ
    - количества использованного RAM
    - утилизации пространства на дисках
    - количество поднятых контейнеров
    - аптайм
    - ...
    - фантазируйте)
    
    ---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---

