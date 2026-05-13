# SQLite Manager для Delphi

Standalone приложение для управления SQLite базами данных, написанное на Delphi 13 (Alexandria).

## Требования

- **Delphi 10.4.2 Alexandria** или новее
- **Windows 10/11** (32-bit или 64-bit)
- **SQLite3.dll** (включена в комплект или скачать отдельно)

## Структура проекта

```
sqlite-manager-delphi/
├── SQLiteManager.dpr         # Главный файл проекта
├── MainForm.pas / .dfm       # Главная форма
├── DBModule.pas              # Модуль работы с SQLite
├── SQLite3.pas               # Обёртка над sqlite3.dll
├── ImportExport.pas          # Импорт/экспорт
├── CreateTreeForm.pas / .dfm # Диалог создания таблицы
├── OptionsForm.pas / .dfm    # Диалог настроек
├── AboutForm.pas / .dfm      # Диалог "О программе"
├── SQLDialogForm.pas / .dfm  # Диалог SQL
└── README.md                 # Этот файл
```

## Установка

### Шаг 1: Скачайте SQLite3.dll

Если у вас ещё нет `sqlite3.dll`, скачайте его:

1. Перейдите на https://www.sqlite.org/download.html
2. Скачайте **Precompiled Binaries for Windows**:
   - `sqlite-dll-win64-x64-*.zip` (для 64-bit)
   - `sqlite-dll-win32-x86-*.zip` (для 32-bit)
3. Распакуйте `sqlite3.dll` в:
   - Папку проекта, или
   - `C:\Windows\System32` (для 64-bit), или
   - `C:\Windows\SysWOW64` (для 32-bit)

### Шаг 2: Откройте проект в Delphi

1. Запустите **Delphi 10.4.2 Alexandria**
2. Откройте файл `SQLiteManager.dpr`
3. Соберите проект: **Project → Build** или `Ctrl+F9`

### Шаг 3: Запустите приложение

Нажмите `F9` для запуска в режиме отладки или найдите `.exe` файл в папке проекта.

## Сборка исполняемого файла

### Компиляция

```
Project → Build
```

Или используйте командную строку:

```batch
msbuild SQLiteManager.dproj /t:Build
```

### Настройки компилятора

Рекомендуемые настройки в **Project → Options**:

- **Building → Output**:
  - Output directory: `.\bin\`
  - Unit output directory: `.\dcu\`
  
- **Building → Packages**:
  - Link with runtime packages: **No** (для standalone exe)
  
- **Building → Debugging**:
  - Debug information: **No** (для релиза)
  - Local symbols: **No**
  
- **Delphi Compiler → Linking**:
  - Map file: **Detailed**
  - Use imported library: **Yes**

## Создание установщика

### Вариант 1: Inno Setup

1. Установите [Inno Setup](https://jrsoftware.org/isdl.php)
2. Создайте скрипт `setup.iss`:

```iss
[Setup]
AppName=SQLite Manager
AppVersion=1.0.0
DefaultDirName={autopf}\SQLiteManager
DefaultGroupName=SQLite Manager
OutputDir=installer
OutputBaseFilename=SQLiteManagerSetup

[Files]
Source: "bin\SQLiteManager.exe"; DestDir: "{app}"
Source: "sqlite3.dll"; DestDir: "{app}"
Source: "README.md"; DestDir: "{app}"

[Icons]
Name: "{group}\SQLite Manager"; Filename: "{app}\SQLiteManager.exe"
Name: "{autodesktop}\SQLite Manager"; Filename: "{app}\SQLiteManager.exe"
```

3. Скомпилируйте: `ISCC.exe setup.iss`

### Вариант 2: Advanced Installer

Используйте Advanced Installer для создания MSI установщика.

## Возможности

### Реализовано

✅ Создание новой базы данных  
✅ Открытие существующей базы  
✅ Просмотр структуры БД (таблицы, представления, индексы, триггеры)  
✅ Просмотр данных с пагинацией  
✅ Выполнение SQL запросов  
✅ Создание таблиц через диалог  
✅ Экспорт в CSV, SQL, XML  
✅ Импорт из CSV, SQL, XML  
✅ Настройки приложения  
✅ Последние открытые базы  

### В разработке

⏳ Создание представлений  
⏳ Создание триггеров  
⏳ Сортировка по клику на заголовке таблицы
⏳ Показ таблиц с другой БД (через ATTACH)   
⏳ Изменение строки таблицы - не записывать неизмененные поля
⏳ Отображение БЛОБА в желаемом виде
⏳ Цвета в форме редактирования записи
⏳ История БД неверно работает с пробелом - считает такие пути за раздельные записи
⏳ При добавлении записи автоинкрементное поле помечать желтым и позволять добавлять с незаполненным полем


## Горячие клавиши

| Клавиши | Действие |
|---------|----------|
| `Ctrl+N` | Новая база данных |
| `Ctrl+O` | Открыть базу данных |
| `Ctrl+W` | Закрыть базу данных |
| `F5` | Обновить |
| `Ctrl+;` | Выполнить SQL |
| `Alt+F4` | Выход |

## Настройки

Настройки хранятся в файле `SQLiteManager.ini`:

```ini
[Options]
ConfirmDrop=1
ConfirmDelete=1
ReconnectLastDb=0
MaxRecent=10
DefaultLimit=100
ShowRowNumbers=1
HighlightSQL=1
CSVDelimiter=0
CSVHeaders=1
BlobDisplay=0
```

## Архитектура

### SQLite3.pas

Низкоуровневая обёртка над функциями `sqlite3.dll`:
- Динамическая загрузка библиотеки
- Прямой вызов API SQLite3

### DBModule.pas

Высокоуровневый класс `TSQLiteHandler`:
- Управление подключением
- Выполнение запросов
- Импорт/экспорт
- Транзакции

### MainForm.pas

Главная форма приложения:
- Меню и панель инструментов
- Дерево структуры БД
- Таблицы для просмотра данных
- SQL редактор

## Отладка

### Включение логирования

Добавьте в `DBModule.pas`:

```delphi
const
  DEBUG_MODE = True;
  
procedure TSQLiteHandler.Log(const AMsg: string);
begin
  if DEBUG_MODE then
    OutputDebugString(PChar(AMsg));
end;
```

### Обработка ошибок

Все ошибки сохраняются в свойство `LastError`:

```delphi
if not FDB.ExecuteSQL(SQL).Success then
  ShowMessage('Error: ' + FDB.LastError);
```

## Распространённые ошибки

### "Cannot load sqlite3.dll"

**Решение:**
1. Убедитесь, что `sqlite3.dll` находится в той же папке, что и `.exe`
2. Проверьте разрядность DLL (32-bit для Win32, 64-bit для Win64)

### "Database is locked"

**Решение:**
- Закройте другие приложения, использующие эту БД
- Увеличьте timeout: `sqlite3_busy_timeout(FDB, 10000)`

### "Access violation"

**Решение:**
- Проверьте, что база открыта перед запросом
- Освобождайте ресурсы в `finally` блоках

## Лицензия

MPL-1.1 (Mozilla Public License)

## Ссылки

- [SQLite Official Site](https://www.sqlite.org/)
- [Delphi 13 Documentation](https://docwiki.embarcadero.com/RADStudio/Alexandria/en/Main_Page)
- [Original Firefox Extension](https://github.com/lazierthanthou/sqlite-manager)

## Версии

### 1.0.0 (2026)
- Первоначальный релиз
- Базовый функционал управления БД
- Импорт/экспорт CSV, SQL, XML
- Настройки приложения
- Редактирование записей
- История SQL запросов
