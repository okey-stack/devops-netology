1. #### Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`.
    `strace -e trace=file /bin/bash -c "cd /tmp"`. Видим что c /tmp 2 системных вызова - `stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=4096, ...}) = 0` и `chdir("/tmp")`.  
   Смотрим man по
   этим системным вызовам:  
   1. `man 2 stat` - получить информацию о файле (в нашем случае `/tmp`) - права доступа, размер.  
   1. `man 2 chdir` - изменяет текущий рабочий каталог вызывающего процесса на каталог, указанный в path - `/tmp` 
1. #### Попробуйте использовать команду `file` на объекты разных типов на файловой системе. Например:
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
    #### Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.  
   `file` определяет тип файла. `file` для каждого параметра делает 3 теста - тест файловой системы, магический тест и языкавой тест.
   Первый тест который завершится успехом будет напечатан.
   1. Тест файловой системы основан на системном вызове stat. Он определяет не пустой ли файл или это какой-то специальный системный файл - символическая ссылка, 
   сокет, именованный канал или другой системный файл описанный в системном файле `sys/stat.h`  
      `lstat("/dev/tty", {st_mode=S_IFCHR|0666, st_rdev=makedev(0x5, 0), ...}) = 0`
   1. Магический тест - проверяет налчие магичекого значения в определенном месте в начале файла. Формат определяется в файлах:  
   >stat("/home/vagrant/.magic.mgc", 0x7fffe545a170) = -1 ENOENT (No such file or directory)  
   stat("/home/vagrant/.magic", 0x7fffe545a170) = -1 ENOENT (No such file or directory)  
   openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)  
   stat("/etc/magic", {st_mode=S_IFREG|0644, st_size=111, ...}) = 0  
   openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
   openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3  
   
   1. Если файл не соответствует ни одной из записей в magic файле, он исследуется, чтобы понять, является ли он текстовым 
      файлом и на каком языке написан по заголовкам. Всевозможные кодировки можно определить по последовательноястям байт.
      Эти проверки менее надежны чем предыдущие. Судя по всему (`cat /usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache`)
      кодировки и лежат тут  
      `openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache", O_RDONLY) = 3
`
1. #### Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).  
   `cat /prox/PID/fd/№ > /tmp/file` -> перенаправить данные из файл в памяти в наш файл на диске
   `kill -USR1 PID`. Соответственно запущенное приложение с PID должно уметь обрабатывать данный сигнал 
1. #### Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?
   Практически нет т.к. сам процесс отработал и вышел на exit статус. Но он будет немного потреблять памяти в ядре, а так же держать файловый дескриптор, кол-во которых ограничено в системе  
1. #### В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
    #### На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).  
   `man 2 open` -> open group -> open, openat, creat  
   `strace -t -e open,openat,creat opensnoop-bpfcc`  
   
            `14:10:12 openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
         14:10:12 openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
         14:10:12 openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
         14:10:12 openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libdl.so.2", O_RDONLY|O_CLOEXEC) = 3
         14:10:12 openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libutil.so.1", O_RDONLY|O_CLOEXEC) = 3
         14:10:12 openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libm.so.6", O_RDONLY|O_CLOEXEC) = 3
         14:10:12 openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libexpat.so.1", O_RDONLY|O_CLOEXEC) = 3
         14:10:12 openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
         14:10:12 openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
         14:10:12 openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache", O_RDONLY) = 3
         14:10:12 openat(AT_FDCWD, "/usr/bin/pyvenv.cfg", O_RDONLY) = -1 ENOENT (No such file or directory)
         14:10:12 openat(AT_FDCWD, "/usr/pyvenv.cfg", O_RDONLY) = -1 ENOENT (No such file or directory)
         14:10:12 openat(AT_FDCWD, "/etc/localtime", O_RDONLY|O_CLOEXEC) = 3
         14:10:12 openat(AT_FDCWD, "/usr/lib/python3.8", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
         14:10:12 openat(AT_FDCWD, "/usr/lib/python3.8/encodings/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
         14:10:12 openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/codecs.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
         14:10:12 openat(AT_FDCWD, "/usr/lib/python3.8/encodings", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
         14:10:12 openat(AT_FDCWD, "/usr/lib/python3.8/encodings/__pycache__/aliases.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
         14:10:12 openat(AT_FDCWD, "/usr/lib/python3.8/encodings/__pycache__/utf_8.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3`
   
1. #### Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.  
   `strace uname -a`->`uname`.  
   `man 2 uname` -> `Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}` 

1. #### Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
    #### Есть ли смысл использовать в bash `&&`, если применить `set -e`?  
   В последовательности команд разделенных `;` при возврате ошибке в команде будет попытка выполнить следущую. 
   Если команды разделены `&&` и одна из команд вернула код ошибки - следущая не будет запущена  
   `man` говорит что при установленном set -e прервать скрипт если какая либо каманда в пайплайне вернула не нулевой код. Однако
   >The shell does not exit if the command that fails is part of the command
   list immediately following a while or until keyword, part of the test following the if or elif reserved words,  part  of
   any  command  executed in a && or || list except the command following the final && or ||, any command in a pipeline but
   the last, or if the command's return value is being inverted with !  
   
   Т.е. `&&` является исключением и смысл использовать это слово в связке с `set -e` есть
1. #### Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?  
   `-e` см выше  
   `-u`
   >Treat unset variables and parameters other than the special parameters "@" and "*" as an error when performing parameter
   expansion.   If expansion is attempted on an unset variable or parameter, the shell prints an error message, and, if not
   interactive, exits with a non-zero status.
   
   `-x`  
   >After expanding each simple command, for command, case command, select command, or arithmetic for command,  display  the
   expanded value of PS4, followed by the command and its expanded arguments or associated word list.
   
   `-o` - option pipefail 
   > If set, the return value of a pipeline is the value of the last (rightmost) command to exit with a non-zero sta‐
   tus, or zero if all commands in the pipeline exit successfully.  This option is disabled by default.
   
   Хорошо испольщовать в сенариях т.к. она будет проверять все неустановленныепараметры отличные от @ и * параметры как 
   ошибки при попытке их раскрытия. Будет выводить каждую команду отдельно и выводить код завершения кажой команды 
1. #### Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).  
   `ps -o stat | egrep -v '(^STAT)' | uniq -c -w 1`  
   > 6 Ss 1 R+ 2 S+

         <    high-priority (not nice to other users) - высокий проритет процесса
         N    low-priority (nice to other users) - низкий приоритет процесса
         L    has pages locked into memory (for real-time and custom IO) - имеет заблокированные в памяти страницы
         s    is a session leader - лидер сессии. В ps aux это /bin/init
         l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do) - многопоточный процесс
         +    is in the foreground process group  - находится в проритетной группе процесов


