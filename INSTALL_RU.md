# Инструкция по установке и запуску SQLite Manager (Delphi)

## Быстрый старт

### Что вам понадобится

1. **Delphi 13 Alexandria** (или новее)
2. **sqlite3.dll** (библиотека SQLite)

### Шаг 1: Установка sqlite3.dll

#### Вариант А: Скачать готовую библиотеку

1. Перейдите на https://www.sqlite.org/download.html
2. В разделе **Precompiled Binaries for Windows** скачайте:
   - **sqlite-dll-win64-x64-*.zip** (для 64-битной версии)
   - **sqlite-dll-win32-x86-*.zip** (для 32-битной версии)
3. Распакуйте `sqlite3.dll` в папку проекта:
   ```
   d:\sqlite-manager-master\sqlite-manager-delphi\
   ```

#### Вариант Б: Использовать системную библиотеку

Если SQLite уже установлен в системе, скопируйте `sqlite3.dll` в:
- `C:\Windows\System32` (для 64-bit)
- `C:\Windows\SysWOW64` (для 32-bit)

### Шаг 2: Открытие проекта в Delphi

1. Запустите **Delphi 13 Alexandria**
2. Выберите **File → Open**
3. Найдите файл `SQLiteManager.dpr` в папке проекта
4. Нажмите **Open**

### Шаг 3: Компиляция

1. В меню выберите **Project → Build** (или нажмите `Ctrl+F9`)
2. Дождитесь завершения компиляции
3. В окне **Messages** должно появиться сообщение об успешной компиляции

### Шаг 4: Запуск приложения

Нажмите `F9` для запуска в режиме отладки или найдите скомпилированный `.exe` файл в папке проекта.

---

## Подробная настройка

### Настройка Delphi для проекта

#### Настройка путей поиска

1. **Project → Options → Delphi Compiler → Search Path**
2. Добавьте: `.;.\src`

#### Настройка выходных файлов

1. **Project → Options → Building → Output**
2. Установите:
   - **Output directory**: `.\bin\`
   - **Unit output directory**: `.\dcu\`
   - **DCU making**: Make modified units

#### Опции компиляции

1. **Project → Options → Delphi Compiler → Compiling**
2. Включите:
   - ✅ **Optimization**
   - ✅ **Stack frames**
   - ✅ **Show hints and warnings**

### Создание релизной версии

1. В панели инструментов выберите **Release** вместо **Debug**
2. **Project → Options → Building**
3. Отключите:
   - ❌ **Debug information**
   - ❌ **Local symbols**
   - ❌ **Reference info**
4. **Project → Build**

---

## Создание установщика

### С помощью Inno Setup

1. Установите [Inno Setup Compiler](https://jrsoftware.org/isdl.php)

2. Создайте файл `installer.iss`:

```iss
#define MyAppName "SQLite Manager"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "SQLite Manager Team"
#define MyAppExeName "SQLiteManager.exe"

[Setup]
AppId={{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
OutputDir=installer
OutputBaseFilename=SQLiteManagerSetup
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[Files]
Source: "bin\SQLiteManager.exe"; DestDir: "{app}"
Source: "sqlite3.dll"; DestDir: "{app}"
Source: "README.md"; DestDir: "{app}"; Flags: isreadme
Source: "INSTALL_RU.md"; DestDir: "{app}"

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{userprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
```

3. Скомпилируйте установщик:
   ```batch
   "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" installer.iss
   ```

4. Готовый установщик появится в папке `installer\`

---

## Решение проблем

### Ошибка: "Cannot load sqlite3.dll"

**Причина:** Библиотека не найдена

**Решение:**
1. Убедитесь, что `sqlite3.dll` находится в той же папке, что и `SQLiteManager.exe`
2. Проверьте разрядность DLL:
   - Для 32-битного приложения нужна 32-битная версия DLL
   - Для 64-битного приложения нужна 64-битная версия DLL
3. Проверьте, что DLL не повреждена

### Ошибка: "Access violation at address..."

**Причина:** Попытка доступа к закрытой базе данных

**Решение:**
```delphi
if FDB.IsOpen then
  // выполняем операции
else
  ShowMessage('Database is not open');
```

### Ошибка компиляции: "File not found: DBModule.pas"

**Решение:**
1. Проверьте, что все файлы проекта находятся в одной папке
2. **Project → Add to Project** и добавьте недостающие файлы

### Приложение не запускается

**Решение:**
1. Запустите от имени администратора
2. Проверьте, что все зависимости установлены
3. Временно отключите антивирус

---

## Структура файлов проекта

```
sqlite-manager-delphi/
├── SQLiteManager.dpr       # Главный файл проекта
├── SQLiteManager.dproj     # Файл проекта MSBuild
├── MainForm.pas/.dfm       # Главная форма
├── DBModule.pas            # Работа с SQLite
├── SQLite3.pas             # Обёртка над sqlite3.dll
├── CreateTreeForm.pas/.dfm # Создание таблицы
├── OptionsForm.pas/.dfm    # Настройки
├── AboutForm.pas/.dfm      # О программе
├── SQLDialogForm.pas/.dfm  # SQL диалог
├── ImportExport.pas        # Импорт/экспорт
├── sqlite3.dll             # Библиотека SQLite (нужно скачать)
└── README.md               # Документация
```

---

## Горячие клавиши в Delphi IDE

| Клавиши | Действие |
|---------|----------|
| `F9` | Запуск отладки |
| `Ctrl+F9` | Компиляция |
| `F12` | Переключение форма/код |
| `Shift+F12` | Меню форм |
| `Ctrl+F12` | Переход к модулю |
| `F11` | Шаги с заходом |
| `F8` | Шаги без захода |
| `F7` | Трассировка |
| `F4` | Выполнить до курсора |
| `F5` | Добавить/удалить точку останова |

---

## Модификация проекта

### Добавление новой формы

1. **File → New → VCL Forms Application**
2. Сохраните форму: **File → Save As**
3. Добавьте форму в проект:
   ```delphi
   uses
     NewForm in 'NewForm.pas' {frmNew};
   ```
4. Добавьте форму в `.dpr` файл:
   ```delphi
   Application.CreateForm(TfrmNew, frmNew);
   ```

### Изменение иконок

1. Откройте форму в дизайнере
2. Выделите компонент `ImageList`
3. Дважды кликните для редактирования
4. Добавьте новые изображения

### Изменение стилей

Для изменения внешнего вида используйте **VCL Styles**:

1. **Project → Options → Application → Appearance**
2. Выберите стиль: **Windows**, **Windows10**, и т.д.

---

## Производительность

### Оптимизация работы с БД

```delphi
// Используйте транзакции для массовых операций
FDB.BeginTransaction;
try
  for I := 1 to 1000 do
    FDB.ExecuteSQL('INSERT INTO ...');
  FDB.CommitTransaction;
except
  FDB.RollbackTransaction;
  raise;
end;

// Используйте подготовленные выражения
// (требуется доработка в DBModule.pas)
```

### Кэширование результатов

```delphi
// Кэшируйте структуру БД
var
  FCachedStructure: TDatabaseStructure;
  FStructureCached: Boolean;

procedure RefreshStructure;
begin
  if FStructureCached then
    Exit;
  
  FCachedStructure := FDB.GetDatabaseStructure;
  FStructureCached := True;
end;
```

---

## Контакты и поддержка

- GitHub: https://github.com/OlegChernavin/sqlite-manager-delphi
- Баг-трекер: https://github.com/OlegChernavin/sqlite-manager-delphi/issues

## Лицензия

MPL-1.1 (Mozilla Public License 1.1)
