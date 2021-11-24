### Main task  
Playbook состоит из 3 play, помеченных разными тегами 
  - env - Создает окружение (docker контейнеры)
  - java - Устанавливает java на все инстансы
  - elastic - Устанавливаем и настраиваем elasticsearch
  - kibana - Устанавливаем и настраиваем kibana
---
  #### env
```yaml
name: Run elasticsearch container # Имя таски
  docker_container:               # Модуль дял работы с docker
    name: elasticsearch           # Имя контейнера
    recreate: yes                 # Принудительно пересоздавать контейнер
    force_kill: true              # Удалять контейнер при остановке
    image: pycontribs/ubuntu      # Образ
    command: sleep infinity       # процесс для работы контейнера в демон режиме
  tags: env                       # тег для тасок создания окружения           
```
  #### java
```yaml
name: Install Java
  hosts: elasticsearch, kibana    # Установим java для указанных групп хостов 
  tasks:
    - name: Set facts for Java 11 vars
      set_fact:
        java_home: "/opt/jdk/{{ java_jdk_version }}" # установим факт с домашней дирректорией java 
      tags: java                  # Тегируем все таски соотв тегом
    - name: Upload .tar.gz file containing binaries from local storage
      copy:
        src: "{{ java_oracle_jdk_package }}" # Скопируем файл из дирректории files/
        dest: "/tmp/jdk-{{ java_jdk_version }}.tar.gz"
      register: download_java_binaries
      until: download_java_binaries is succeeded # Выполняем таску пока не скопируется файл
      tags: java
    - name: Ensure installation dir exists # Создадим дирректорию для java
      become: true  # в привилигированном режиме (default root)
      file:
        state: directory
        path: "{{ java_home }}"
      tags: java
   ...
    - name: Export environment variables # Создадим скрипт для установки переменных окружения через шаблон
      become: true
      template:
        src: jdk.sh.j2 # template из папки templates
        dest: /etc/profile.d/jdk.sh # поместим его сюдя для запуска и создания окружения 
      tags: java           
```
  #### elasticsearch
```yaml
...
tasks:
    - name: Upload tar.gz Kibana from remote URL # Скачаем архив с БД с оф сайта
      get_url: 
        url: "https://artifacts.elastic.co/downloads/kibana/kibana-{{ kibana_version }}-linux-x86_64.tar.gz" # Откуда
        dest: "/tmp/kibana-{{ kibana_version }}-linux-x86_64.tar.gz" # Куда
        mode: 0755 # Установим права на файл
        timeout: 60  # таймаут запроса
        force: true  # Скачиваем файл каждый рах при его изминении
        validate_certs: false # Не проверяем SSL сертификаты
      register: get_kibana # Результат запишем в переменную для понимания окончания скачивания
      until: get_kibana is succeeded
      tags: kibana    
...
```
  
### Additional task
