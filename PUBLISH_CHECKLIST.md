# Чеклист публикации на GitHub

Выполните один раз перед пушем в публичный репозиторий.

## 1. Файлы в репозитории (уже добавлены)

- [x] `.gitignore` — исключает сборку, DCU, DLL, `__history/`, локальные INI
- [x] `LICENSE` — MPL 1.1
- [x] `THIRD_PARTY.md` — SynEdit, SQLite, оригинальный проект
- [x] `CONTRIBUTING.md`
- [x] `.gitattributes` — CRLF для Windows/Delphi
- [x] `.github/ISSUE_TEMPLATE/` — баги и фичи
- [x] `.github/PULL_REQUEST_TEMPLATE.md`

## 2. Убрать из индекса Git (если уже закоммичены)

В PowerShell из корня проекта:

```powershell
git rm -r --cached Win32/ 2>$null
git rm --cached Win32/Debug/SQLiteManager.ini 2>$null
git rm --cached sqlite3.dll 2>$null
git status
```

Закоммитьте очистку отдельным коммитом, например: `chore: stop tracking build artifacts and local settings`.

## 3. Настройки репозитория на GitHub

- **Description:** Standalone SQLite database manager for Windows (Delphi VCL)
- **Topics:** `delphi`, `sqlite`, `vcl`, `database`, `windows`, `pascal`
- **License:** Mozilla Public License 2.0 *не подходит* — выберите **Other** и укажите MPL 1.1 в README, либо оставьте без автодетекта (файл `LICENSE` уже в корне)
- Отключите **Wiki**, если не нужен
- Включите **Issues**

## 4. Секреты

- Не публикуйте API-ключи AI (`AIService`, настройки в INI).
- Файл `SQLiteManager.ini` в `.gitignore` — пользовательские настройки локально.

## 5. Сборка для релиза (опционально)

1. Release + `sqlite3.dll` (x86/x64) в Assets
2. Краткие release notes из [README.md](README.md#версии)

## 6. Remote

```powershell
git remote -v
# origin → https://github.com/OlegChernavin/sqlite-manager-delphi.git
git push -u origin main
```
