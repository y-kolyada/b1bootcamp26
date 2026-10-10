# b1bootcamp26

**AI Bootcamp, autumn 2026 — course materials.**
**AI Bootcamp, осень 2026 — материалы курса.**

The AI executes — you decide. / ИИ исполняет — ты решаешь.

---

## Перед первым занятием

**Всё, что нужно сделать, лежит одним файлом: [«Твой ход 0 · Собери рабочее место»](./sessions/00-tvoy-hod.md).** Там восемь шагов по порядку, с командами, и что прислать тренеру в конце. Начинай оттуда.

Ниже — то же самое коротко, для тех, кто уже знает, что делает.

**Шаг 1 — установка.** Она ставит то, что нужно курсу: редактор, Node.js, Claude Code и `gh`. Сначала в Windows, потом в Ubuntu.

В **Windows PowerShell** — редактор:

```powershell
.\setup-windows.ps1 -Lang ru
```

Потом закрой и открой редактор, в нём `Ctrl+Shift+P` → `WSL: Connect to WSL`, открой терминал Ubuntu и запусти:

```bash
git clone https://github.com/y-kolyada/b1bootcamp26.git
cd b1bootcamp26
./setup.sh --ru
```

Установщик **ничего не удаляет**, в твои файлы не пишет без вопроса и **почти нигде не требует пароля**. Единственное место, где нужен родитель, он печатает отдельно и крупно. Хочешь сначала посмотреть, что он собирается делать, и ничего не менять:

```bash
./setup.sh --ru --dry-run
```

**Шаг 2 — проверка.** Она ничего не ставит и не меняет: смотрит и говорит, готово ли.

```bash
./check-setup.sh --ru
```

**Сам факт, что скачивание получилось, уже проверяет `git` и доступ к GitHub** — две из одиннадцати позиций списка.

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

Teams, Telegram, веб-камеру, микрофон и то, что подписка оформлена родителем. Эти пять пунктов скрипт печатает отдельным списком и **не делает вид, что их проверил.**

---

## Before the first session

**The whole thing is one file: [`sessions/00-tvoy-hod.md`](./sessions/00-tvoy-hod.md)** - eight steps in order, in Russian, with the commands and what to send the trainer. Start there. The short form follows.

**Step 1 — setup.** In **Windows PowerShell**, the editor:

```powershell
.\setup-windows.ps1
```

Then reopen the editor, `Ctrl+Shift+P` → `WSL: Connect to WSL`, and in the Ubuntu terminal:

```bash
git clone https://github.com/y-kolyada/b1bootcamp26.git
cd b1bootcamp26
./setup.sh            # --ru, --uk, --de for the other languages
./setup.sh --dry-run   # say what it would do, change nothing
```

It deletes nothing, writes into your own files only after asking, and needs a password in exactly one place, which it prints as a block of its own.

**Step 2 — the check.** It installs nothing and changes nothing.

```bash
./check-setup.sh
```

**Getting the clone at all already tests `git` and GitHub access** — two of the eleven items. The script looks, and prints `OK`, `FAIL` or `LOOK` per item, with one line per `FAIL` saying what to do. The last line is a one-line report to send to the trainer.

---

## Как устроен этот репозиторий

| Где | Что |
| --- | --- |
| корень | то, что запускает участник: `setup.sh`, `setup-windows.ps1`, `check-setup.sh` |
| `sessions/` | по одному «Твоему ходу» на занятие, плюс нулевой |
| `programme.md` | программа курса: восемь занятий и что каждое оставляет |
| `programme-review.md` | ревью программы: кто её читал и что вернул |
| `tools/` | **не для участников** — проверки самого репозитория |

**Скрипты лежат в корне нарочно.** Это первое, что запускает человек, который ещё не знает, где у нас что; лишняя папка на этом пути — лишний шанс не дойти.

---

## Что это за курс

Не про то, как писать запросы к ИИ — про то, **как вести разработку, когда работу делает ИИ, а решения принимаешь ты.** Восемь занятий, один продукт, три артефакта: **задание · запись · проверка.** В конце у каждого участника свой продукт, опубликованный в интернете, и своя маленькая фабрика, которая его проверяет.
