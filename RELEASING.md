# Релиз и установщик

Краткая инструкция: собрать **Release**, упаковать **Inno Setup**, опубликовать **GitHub Release**.

## 1. Подготовка

| Что | Где |
|-----|-----|
| Delphi 10.4+ | IDE |
| SynEdit | пакет в IDE ([THIRD_PARTY.md](THIRD_PARTY.md)) |
| **sqlite3.dll** (Win32, x86) | корень проекта, рядом с `.dproj` |
| [Inno Setup 6](https://jrsoftware.org/isdl.php) | `ISCC.exe` |

Версию релиза меняйте в двух местах:

- `installer.iss` → `#define MyAppVersion "1.0.0"`
- `AboutForm.dfm` → `Version: 1.0.0` (по желанию)

## 2. Сборка exe (Release, Win32)

**В Delphi:**

1. Конфигурация **Release**, платформа **Win32**
2. **Project → Options → Building** — для релиза отключите debug info
3. **Project → Build** (`Shift+F9`)

Результат: `Win32\Release\SQLiteManager.exe`

**Или скрипт** (если установлен RAD Studio и Inno):

```powershell
cd d:\sqlite-manager-master\sqlite-manager-delphi
.\scripts\build-installer.ps1
```

## 3. Установщик (Inno Setup)

Файл скрипта: [`installer.iss`](installer.iss)

```powershell
& "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe" installer.iss
```

Готовый файл:

```
installer\SQLiteManagerSetup-1.0.0-Win32.exe
```

Папка `installer\` в `.gitignore` — **установщик в Git не коммитят**, только на Releases.

### Проверка перед публикацией

- [ ] Установка на чистой VM / другом ПК
- [ ] Запуск exe, открытие `.db`
- [ ] Разрядность: Win32 exe + **x86** `sqlite3.dll`

## 4. GitHub Release

### Вариант A — веб-интерфейс

1. Закоммитьте и запушьте исходники в `main`
2. **Releases → Draft a new release**
3. **Choose a tag:** `v1.0.0` → Create new tag on `main`
4. **Release title:** `v1.0.0`
5. Описание (changelog)
6. **Attach binaries:** перетащите `SQLiteManagerSetup-1.0.0-Win32.exe`
7. Опционально отдельно: `sqlite3.dll` (для portable без установщика)
8. **Publish release**

### Вариант B — GitHub CLI (`gh`)

```powershell
cd d:\sqlite-manager-master\sqlite-manager-delphi

# Тег на текущем коммите
git tag -a v1.0.0 -m "Release 1.0.0"
git push origin v1.0.0

gh release create v1.0.0 `
  --title "SQLite Manager 1.0.0" `
  --notes-file RELEASE_NOTES_v1.0.0.md `
  "installer\SQLiteManagerSetup-1.0.0-Win32.exe"
```

Пример `RELEASE_NOTES_v1.0.0.md`:

```markdown
## SQLite Manager 1.0.0 (Win32)

- Первый публичный установщик
- Требуется Windows 10+
- В комплекте sqlite3.dll (x86)

### Установка
Запустите `SQLiteManagerSetup-1.0.0-Win32.exe` или распакуйте portable (exe + dll).
```

## 5. Что не класть в Release / Git

- `*.dcu`, `Win32\Debug\`
- `SQLiteManager.ini` (настройки пользователя)
- API-ключи AI

## 6. Следующие версии

1. Поднять версию в `installer.iss` и теге (`v1.0.1`)
2. `.\scripts\build-installer.ps1`
3. `gh release create v1.0.1 ...` с новым `.exe`

## Ссылки

- [PUBLISH_CHECKLIST.md](PUBLISH_CHECKLIST.md) — первичная публикация репозитория
- [GitHub: Managing releases](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository)
