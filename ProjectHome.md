![https://dl.dropbox.com/u/836287/Dev/StatusManager/2.x/Screenshots/Main%20window.png](https://dl.dropbox.com/u/836287/Dev/StatusManager/2.x/Screenshots/Main%20window.png)

### Возможности плагина ###
  * Установка Х-Статусов из базы данных плагина;
  * Автоматическое сохранение Х-Статусов в базу данных;
  * Контакт в списке контактов;
  * Кнопка в окне сообщений;
  * Простой, удобный и современный интерфейс;
  * Загрузка элементов интерфейса из текущего скина;
  * Автоматическое скрытие в режиме анти-босс;
  * Полная поддержка Unicode и многострочных статусов;
  * База данных на движке SQLite;
  * Поддержка обновлений с помощью QIP Manager.

### Установка ###
  * Поддерживается QIP начиная с версии 8470
  * Для установки плагина распаковать архив в папку QIP\Plugins
  * Требует для работы библиотеку SQLite (sqlite3.dll) либо в QIP\Core либо в папке с плагином (QIP\Plugins\StatusManager). Библиотека входит в комплект поставки QIP 2012 начиная с версии 8701, для более старых версий её можно скачать отдельно

### Importer - утилита импорта ###
Позволяет импортировать базу статусов из формата других плагинов в базу данных SQLite плагина Status Manager 2.x (по умолчанию файл Profiles\%ProfileName%\Plugins\StatusManager\Datab ase.sqlite)
В версии 3.0 поддерживаются форматы:
  * Status Manager 0.x (по умолчанию файл Profiles\%ProfileName%\Plugins\StatusManager\XStat us.db)
  * SetXStatus 4.x (по умолчанию файл Profiles\%ProfileName%\Plugins\SetXStatus\Base\myx status.dic)
  * X-Statuses Collection 0.x (по умолчанию файл Profiles\%ProfileName%\Plugins\xstatus\_collection\ xStatuses.db)
Требует для работы библиотеку sqlite3.dll в папке с исполняемым файлом утилиты