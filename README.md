# b1bootcamp26

**AI Bootcamp, autumn 2026 — course materials.**
**AI Bootcamp, осень 2026 — материалы курса.**

The AI executes — you decide. / ИИ исполняет — ты решаешь.

---

## Перед первым занятием: проверка рабочего места

Скачай репозиторий и запусти проверку. **Сам факт, что скачивание получилось, уже проверяет `git` и доступ к GitHub** — две из одиннадцати позиций списка.

```bash
git clone https://github.com/y-kolyada/b1bootcamp26.git
cd b1bootcamp26
./check-setup.sh
```

Скрипт **ничего не устанавливает и ничего не меняет.** Он смотрит и печатает `OK`, `FAIL` или `LOOK` по каждому пункту, а для каждого `FAIL` — одну строку, что сделать. В самом конце — строка отчёта, её нужно прислать тренеру.

### Четыре языка

```bash
./check-setup.sh          # English (по умолчанию)
./check-setup.sh --ru     # русский
./check-setup.sh --uk     # українська
./check-setup.sh --de     # Deutsch
./check-setup.sh --help
```

### Что он проверяет

WSL2 и Ubuntu · `git` с заданными именем и почтой · доступность GitHub · Node.js 18 или новее · редактор (VS Code или Antigravity IDE) и расширение Claude Code в нём · установленный Claude Code · **действительный вход в аккаунт — настоящим запросом к модели, а не наличием файла** · свободное место на диске.

### Чего он проверить не может

Discord, веб-камеру, микрофон и то, что подписка оформлена родителем. Эти четыре пункта скрипт печатает отдельным списком и **не делает вид, что их проверил.**

---

## Before the first session: readiness check

Clone the repository and run the check. **Getting the clone at all already tests `git` and GitHub access** — two of the eleven items.

```bash
git clone https://github.com/y-kolyada/b1bootcamp26.git
cd b1bootcamp26
./check-setup.sh
```

The script **installs nothing and changes nothing.** It looks, and prints `OK`, `FAIL` or `LOOK` per item, with one line per `FAIL` saying what to do. The last line is a one-line report to send to the trainer.

---

## Что это за курс

Не про то, как писать запросы к ИИ — про то, **как вести разработку, когда работу делает ИИ, а решения принимаешь ты.** Восемь занятий, один продукт, три артефакта: **задание · запись · проверка.** В конце у каждого участника свой продукт, опубликованный в интернете, и своя маленькая фабрика, которая его проверяет.
