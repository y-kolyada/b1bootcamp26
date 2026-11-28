"""Итоговая дека тренера по курсу AI Bootcamp, русская. Движок (CSS, JS, рамка) - копия talkaos в этой папке, слайды здесь.

Цифры сняты 2026-11-28 с голов двух репозиториев, названных в шпаргалке титульного слайда.
Сборка: python3 courses/b1bootcamp26/deck/builder/build-ru.py
Правила деки: без фактов о конкретных детях, только общие цифры; без продажи (курс бесплатный, тренеры - волонтёры).
"""
import sys, pathlib
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
from deck_engine import assemble

SRC = str(HERE / "engine" / "agent-mcp-deck-ru.html")
OUT = str(HERE.parent / "course-deck-ru.html")

CSS = """
  .quotes { display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px 18px; margin-top: 16px; }
  .quotes .q { background: var(--panel); border-left: 3px solid var(--accent); padding: 10px 14px; font-size: clamp(14px, 1.35vw, 17px); }
  .quotes .q b { display: block; font-family: var(--font-mono); font-size: 12px; letter-spacing: .06em; text-transform: uppercase; color: var(--muted); font-weight: 500; margin-bottom: 4px; }
  .quotes .q.steel { border-left-color: var(--steel); }
  .prompt { font-family: var(--font-mono); font-size: clamp(13.5px, 1.3vw, 16px); color: var(--ink); background: var(--panel);
            border-left: 3px solid var(--accent); padding: 12px 16px; margin: 12px 0 4px; line-height: 1.5; }
  .prompt .who { display: block; font-size: 12px; letter-spacing: .06em; text-transform: uppercase; color: var(--muted); margin-bottom: 4px; }
  .out { font-family: var(--font-mono); font-size: clamp(13px, 1.25vw, 15.5px); background: var(--panel-2); padding: 10px 14px; border-radius: 6px; margin-top: 8px; }
  .out .g { color: #2e8b57; } .out .r { color: #c0392b; }
  @media (max-width: 900px) { .quotes { grid-template-columns: 1fr; } }
"""

SL = []
def slide(sec, tier, body, notes): SL.append((sec, tier, body, notes))

def flow(nodes, accent=()):
    out = []
    for i, (k, v) in enumerate(nodes):
        cls = "node accent" if i in accent else "node"
        out.append(f'<div class="{cls}"><div class="n-k">{k}</div><div class="n-v">{v}</div></div>')
    return '<div class="hscroll"><div class="flow">' + '<div class="arrow"></div>'.join(out) + '</div></div>'

# ---------------------------------------------------------------- титул
slide("О докладе", "core", '''
      <p class="eyebrow">AI Bootcamp &middot; ИИ исполняет - ты решаешь</p>
      <h1 class="title">Как мы делали этот курс<br>и <span class="brass">как его проводили</span></h1>
      <p class="lede">Восемь недель вы работали с ИИ по одному правилу: сначала задание, потом просьба, потом проверка. Тренер делал свою работу по тому же правилу - сайт курса собран так же, как ваши сайты.</p>
      <div class="title-meta">
        <span><b>ЗАНЯТИЯ:</b> 8 &middot; страница, задание и запись у каждого</span>
        <span><b>СТРАНИЦЫ:</b> 80 на 8 языках</span>
        <span><b>ПРОВЕРКА:</b> 14 предикатов, 77 строк ДА</span>
        <span><b>КОММИТЫ:</b> 73 сайта и 29 программы</span>
      </div>''', '''
      <p class="timing">ТИТУЛ &middot; ~30 секунд.</p>
      <p><strong>Одна фраза:</strong> «Всё, чего мы требовали от вас, тренер делал сам. Покажу, как это выглядело с нашей стороны, и что пошло не по плану».</p>
      <p>Клавиши: <code>&rarr;</code> дальше, <code>N</code> заметки, <code>O</code> обзор, <code>C</code> резерв, <code>T</code> тема.</p>
      <div class="cockpit">
        <p><strong>Источники, замер 2026-11-28:</strong> сайт <code>b1bootcamp26-site</code> на <code>9ea7ee1</code>, программа <code>b1bootcamp26</code> на <code>74cf2ee</code>. Коммиты - <code>git rev-list --count HEAD</code>: 73 и 29. Страницы и предикаты - вывод <code>./check.sh</code>: «все 80 страниц для 8 языков», строк ДА 77, предикаты 1-14.</p>
        <p><strong>Не говорить</strong> имён детей, названий их сайтов и кто что сделал. Не продавать: курс бесплатный, тренеры - волонтёры.</p>
      </div>''')

# ---------------------------------------------------------------- 1
slide("1 &middot; Тройка", "core", f'''
      <p class="eyebrow">01 &middot; Те же три вещи</p>
      <h2 class="head">Задание, запись, проверка -<br><span class="brass">и у тренера тоже</span>.</h2>
      {flow([("до работы","zadanie-N.md: три предиката"),("работа","ИИ делает страницу"),("после","zapis-N.md: что вышло"),("проверка","./check.sh: ДА или НЕТ"),("решение","принять или вернуть")], accent=(0,4))}
      <div class="kpis">
        <div class="kpi"><div class="num">8 + 8</div><div class="lbl">заданий и записей сайта курса, по паре на занятие</div></div>
        <div class="kpi"><div class="num">«настоящий»</div><div class="lbl">каждое задание на сайте говорит: «Этот файл - настоящий, а не пример»</div></div>
      </div>
      <p class="why"><b>Зачем</b> &nbsp;Пример, которому учитель сам не следует, ничему не учит. Внизу каждой страницы занятия - ссылки на её задание и запись: можно проверить, что мы делали так же.</p>''', '''
      <p class="timing">СЛАЙД 1 &middot; ~1 минута.</p>
      <p><strong>Показать:</strong> внизу любой страницы занятия ссылки «Её задание» и «Что получилось на самом деле».</p>
      <p><strong>Сказать:</strong> «Когда вы писали zadanie-4.md, я в тот же день писал своё. По нему ИИ делал страницу, которую вы читали».</p>
      <div class="cockpit"><p><strong>Источники:</strong> <code>zadanie-1.md</code> ... <code>zadanie-8.md</code>, <code>zapis-1.md</code> ... <code>zapis-8.md</code> в корне сайта; предикат 12 <code>check.sh</code> держит, что у каждого занятия есть все три.</p></div>''')

# ---------------------------------------------------------------- 2
slide("2 &middot; Проверка", "core", '''
      <p class="eyebrow steel">02 &middot; Проверка сайта курса</p>
      <h2 class="head">Наша проверка <span class="brass">росла</span>,<br>и она тоже врала.</h2>
      <div class="cols three">
        <div class="card"><p class="k">росла</p><h3>14 предикатов</h3><p>Каждое занятие добавляло строки, старые не удалялись. Сейчас 327 строк и 77 ответов ДА на каждый запуск.</p></div>
        <div class="card"><p class="k">краснела</p><h3>Запись забыта</h3><p>Предикат 12 краснел снова и снова на одном месте: страница готова, а записи нет. Проверка помнила про запись за всех.</p></div>
        <div class="card steel"><p class="k">врала</p><h3>Кнопка в никуда</h3><p>Кнопка «свернуть всё» могла вести на чужую страницу, а проверка была зелёной: она искала слово, а не ссылку. Нашли перед занятием 7.</p></div>
      </div>
      <p class="why"><b>То же, что у вас</b> &nbsp;Занятие 7 было про зелёное, которое ничего не доказывает. Сначала мы нашли такую дыру у себя, потом сделали про это занятие.</p>''', '''
      <p class="timing">СЛАЙД 2 &middot; ~1,5 минуты.</p>
      <p><strong>Сказать:</strong> «Проверка, которая ни разу не была красной, - ещё не проверка. Наша была красной много раз, и один раз - зелёной там, где не должна».</p>
      <div class="cockpit"><p><strong>Источники:</strong> <code>wc -l check.sh</code> = 327; <code>./check.sh | grep -c ДА</code> = 77. Предикат 12 - «Красный момент» в <code>zapis-7.md</code>. Дыра предиката 8 - комментарий в <code>check.sh</code> «ДЫРА, НАЙДЕННАЯ 24 НОЯБРЯ ПРОГОНОМ ПРОМПТОВ ЗАНЯТИЯ 7».</p></div>''')

# ---------------------------------------------------------------- 3
slide("3 &middot; Возвраты", "core", '''
      <p class="eyebrow">03 &middot; Возврат</p>
      <h2 class="head">Тренер тоже <span class="brass">возвращал работу ИИ</span>.</h2>
      <div class="quotes">
        <div class="q"><b>занятие 5</b>«Зачем ребёнку набирать это руками?»</div>
        <div class="q"><b>занятие 6</b>«Сайт - универсальный курс, а не страница одной группы».</div>
        <div class="q steel"><b>занятие 7</b>«Ты сама могла проверить промпты, запустив субагента. В чём проблема?»</div>
        <div class="q steel"><b>коммиты</b>«Не пиши в коммите своё соавторство. Ты исполнитель, я архитектор».</div>
      </div>
      <p class="why"><b>Как у вас</b> &nbsp;Каждый возврат записан в zapis-N.md: что вернули и почему. ИИ не обижается и не спорит, он переделывает. Решает тот, кто поставил задание.</p>''', '''
      <p class="timing">СЛАЙД 3 &middot; ~1,5 минуты.</p>
      <p><strong>Сказать:</strong> «Возврат - не ссора и не провал. Это обычная работа: назвал, что не так, получил исправленное».</p>
      <p><strong>Можно добавить:</strong> про соавторство - история коммитов переписана, строка «соавтор ИИ» убрана из всех коммитов сайта и программы.</p>
      <div class="cockpit"><p><strong>Источники:</strong> «Зачем ребёнку набирать это руками?» - <code>zapis-5.md</code>; «Возврат: сайт - универсальный курс» - <code>zapis-6.md</code>; «Ты сама могла...» - <code>zapis-7.md</code>; соавторство - слова тренера 2026-11-24, в записи - раздел «Приёмка» <code>zapis-7.md</code>.</p></div>''')

# ---------------------------------------------------------------- 4
slide("4 &middot; Субагент", "core", f'''
      <p class="eyebrow steel">04 &middot; Первый ученик</p>
      <h2 class="head">Прежде чем промпт попадал к вам,<br>его <span class="brass">проходил субагент</span>.</h2>
      {flow([("субагент","играет агента ученика"),("учебный сайт","викторина, ник kot-geo"),("промпты","слово в слово со страницы"),("отчёт","где слабый агент ошибётся")], accent=(0,))}
      <div class="kpis">
        <div class="kpi"><div class="num">2 + 4</div><div class="lbl">прогона промптов занятия 7 и прогона ворот deploy.sh</div></div>
        <div class="kpi"><div class="num">2</div><div class="lbl">прогона деки сдачи: первый нашёл десять мест, второй - дыру в испытании</div></div>
      </div>
      <p class="why"><b>Зачем</b> &nbsp;Ошибку в промпте дешевле найти у субагента, чем у десяти учеников на занятии. Прогон идёт на модели попроще: так дешевле и ближе к тому, что стоит у вас.</p>''', '''
      <p class="timing">СЛАЙД 4 &middot; ~1 минута.</p>
      <p><strong>Сказать:</strong> «Субагент - это ещё один ИИ, которому мы даём роль. Здесь роль - ваш агент на вашем сайте».</p>
      <p><strong>Подробности в резерве:</strong> слайды «Ворота» и «Испытание».</p>
      <div class="cockpit"><p><strong>Источники:</strong> разделы «Прогон» в <code>zapis-7.md</code> и <code>zapis-8.md</code>. Модель прогонов - Sonnet.</p></div>''')

# ---------------------------------------------------------------- 5
slide("5 &middot; Не по плану", "core", '''
      <p class="eyebrow">05 &middot; Что пошло не по плану</p>
      <h2 class="head">Занятие 6 не получилось -<br>и из этого <span class="brass">выросло занятие 7</span>.</h2>
      <div class="cols three">
        <div class="card"><p class="k">что случилось</p><h3>Не все смогли</h3><p>Кого-то не было, у кого-то кончился недельный лимит, кто-то не смог войти без родителя. Обмен в парах не сложился.</p></div>
        <div class="card"><p class="k">что увидели</p><h3>Проверку переписывали</h3><p>Проверку не наращивали, а писали заново под одно задание. Старые проверки пропадали.</p></div>
        <div class="card steel"><p class="k">чья ошибка</p><h3>Наш промпт</h3><p>Промпт занятия 4 просил «ровно мои предикаты и ничего больше». В него добавлено правило: старые проверки не удаляй.</p></div>
      </div>
      <p class="why"><b>Вывод</b> &nbsp;Так занятие 7 стало про проверку, которая помнит все задания. Программа - это план, а курс - то, что получилось с живыми людьми.</p>''', '''
      <p class="timing">СЛАЙД 5 &middot; ~1,5 минуты.</p>
      <p><strong>Сказать честно:</strong> «Когда у вас не получалось, мы искали причину сначала у себя. Нашли её в собственном промпте».</p>
      <p><strong>Не называть</strong>, кто отсутствовал и у кого что кончилось.</p>
      <div class="cockpit"><p><strong>Источники:</strong> «Сначала - откуда взялось это задание» в <code>zapis-7.md</code>; правило 6 в промпте <code>04.html#min-3</code>; расхождение с программой - резерв «Программа».</p></div>''')

# ---------------------------------------------------------------- 6
slide("6 &middot; Контекст", "core", '''
      <p class="eyebrow steel">06 &middot; Что сработало лучше, чем ждали</p>
      <h2 class="head">Репозиторий помнит,<br>а сайт курса читают <span class="brass">ваши агенты</span>.</h2>
      <div class="prompt"><span class="who">новичок в чужой команде</span>Меня включили в команду разработки сайта. Ознакомься с этим сайтом и скажи, на каком задании остановилась разработка.</div>
      <div class="prompt"><span class="who">самый сильный промпт занятия 7</span>Ознакомься с требованиями к заданиям на сайте курса. Дай мне предложение по следующему шагу.</div>
      <p class="why"><b>Почему это работает</b> &nbsp;Задания и записи - память проекта: агенту хватает прочитать их, чтобы понять, где остановились. А сайт курса написан так, что его понимают и люди, и их агенты.</p>''', '''
      <p class="timing">СЛАЙД 6 &middot; ~1,5 минуты.</p>
      <p><strong>Сказать:</strong> «Мы делали сайт для вас, а оказалось, что он понятен и вашим агентам. Агент прочитал задания курса и сам поставил вам следующее задание».</p>
      <p><strong>Связать с занятием 7:</strong> «что было, помнит репозиторий» - поэтому новой беседе не нужна старая.</p>
      <div class="cockpit"><p><strong>Источники:</strong> промпты тренера на занятии 7, 2026-11-28; адрес сайта курса в промпте - <code>y-kolyada.github.io/b1bootcamp26-site</code>. Этот промпт теперь есть на <code>08.html#vhod</code>.</p></div>''')

# ---------------------------------------------------------------- 7
slide("7 &middot; Дальше", "core", '''
      <p class="eyebrow">07 &middot; Что дальше</p>
      <h2 class="head">Курс заканчивается,<br><span class="brass">репозиторий - нет</span>.</h2>
      <div class="cols three">
        <div class="card"><p class="k">у тебя есть</p><h3>Свой сайт и своя проверка</h3><p>Репозиторий, сайт в интернете, проверка, которая помнит все задания, и дека о том, что ты сделал и как.</p></div>
        <div class="card"><p class="k">следующий шаг</p><h3>zadanie-9.md</h3><p>Новая функция с тремя предикатами. Тренера рядом нет, а предикаты скажут «да» или «нет» не хуже него.</p></div>
        <div class="card steel"><p class="k">главное</p><h3>Решаешь ты</h3><p>ИИ исполняет быстро и много. Что считать сделанным, решает тот, кто написал задание до работы.</p></div>
      </div>
      <p class="why"><b>Одна строка с собой</b> &nbsp;Сначала задание, потом просьба, потом проверка - и решаешь ты.</p>''', '''
      <p class="timing">СЛАЙД 7 &middot; ~1 минута. Последний слайд ядра.</p>
      <p><strong>Закончить словами:</strong> «Спасибо за восемь суббот. ИИ исполняет - вы решаете».</p>
      <p><strong>Без предложений</strong> платного продолжения: курс бесплатный.</p>
      <p>Вопросы - клавиша <code>C</code> открывает резерв.</p>''')

# ---------------------------------------------------------------- резерв
slide("Резерв &middot; Занятия", "ext", '''
      <p class="eyebrow steel">Резерв &middot; занятия в цифрах</p>
      <h2 class="head">Восемь страниц, <span class="brass">восемь пар</span> задание-запись.</h2>
      <table class="grid compact">
        <tr><th>занятие</th><th>шагов</th><th>строк страницы</th><th>строк записи</th></tr>
        <tr><td class="m">1 &middot; Первая поставка</td><td>16</td><td>440</td><td>154</td></tr>
        <tr><td class="m">2 &middot; Требования</td><td>13</td><td>411</td><td>51</td></tr>
        <tr><td class="m">3 &middot; Возврат</td><td>11</td><td>336</td><td>185</td></tr>
        <tr><td class="m">4 &middot; Своя проверка</td><td>10</td><td>319</td><td>39</td></tr>
        <tr><td class="m">5 &middot; Проверка растёт</td><td>9</td><td>512</td><td>63</td></tr>
        <tr><td class="m">6 &middot; Приёмка чужой работы</td><td>12</td><td>434</td><td>62</td></tr>
        <tr><td class="m">7 &middot; Зелёная проверка и цена вопроса</td><td>10</td><td>555</td><td>100</td></tr>
        <tr><td class="m">8 &middot; Сдача</td><td>9</td><td>422</td><td>100</td></tr>
      </table>
      <p class="why"><b>Что видно</b> &nbsp;Шагов на занятии со временем становилось меньше: меньше команд, больше решений. Записи длиннее там, где были возвраты.</p>''', '''
      <p class="timing">РЕЗЕРВ &middot; на вопрос «сколько это работы?»</p>
      <div class="cockpit"><p><strong>Источники, 2026-11-28:</strong> шаги - вывод предиката 7 <code>check.sh</code>; строки - <code>wc -l 0N.html zapis-N.md</code>. Сайт начат 2026-10-08, программа - 2026-09-22.</p></div>''')

slide("Резерв &middot; Программа", "ext", '''
      <p class="eyebrow">Резерв &middot; программа против факта</p>
      <h2 class="head">План держали, <span class="brass">но не цеплялись</span> за него.</h2>
      <table class="grid compact">
        <tr><th>занятие</th><th>по первой программе</th><th>как получилось</th></tr>
        <tr><td class="m">5</td><td>фабрика: проверка сама запускается на GitHub</td><td>проверка растёт; агент сам запускает её после каждой правки</td></tr>
        <tr><td class="m">6</td><td>приёмка чужой работы</td><td>то же, плюс схема ветки и пул-реквеста, понятная ребёнку</td></tr>
        <tr><td class="m">7</td><td>зелёная проверка, которая ничего не доказывает</td><td>+ проверка помнит все задания, + цена вопроса (лимит), + ворота deploy.sh</td></tr>
        <tr><td class="m">8</td><td>показать пять вещей</td><td>пять вещей в своей деке: файл на Pages и артефакт на claude.ai</td></tr>
      </table>
      <p class="why"><b>Правило</b> &nbsp;Слово тренера после занятия важнее старого плана. Программа каждый раз обновлялась вслед за сайтом, а не наоборот.</p>''', '''
      <p class="timing">РЕЗЕРВ &middot; на вопрос «а вы всё делали по плану?»</p>
      <p><strong>Сказать:</strong> «Большая фабрика с проверкой на GitHub не вошла в курс: для неё нужны YAML и настройки репозитория, а у вас уже есть маленькая - агент сам проверяет себя».</p>
      <div class="cockpit"><p><strong>Источники:</strong> <code>programme.md</code> и <code>programme-review.md</code> в репозитории курса; решения - <code>potom.md</code> сайта.</p></div>''')

slide("Резерв &middot; Цена", "ext", '''
      <p class="eyebrow steel">Резерв &middot; цена вопроса - и для нас</p>
      <h2 class="head"><span class="brass">96%</span> - это перечитывание.</h2>
      <div class="kpis">
        <div class="kpi"><div class="num">54 млн</div><div class="lbl">токенов в беседах сайта курса, 13-28 ноября</div></div>
        <div class="kpi"><div class="num">96%</div><div class="lbl">из них - повторное чтение уже прочитанного</div></div>
        <div class="kpi"><div class="num">4%</div><div class="lbl">недельного лимита за день доводки занятия 7 с шестью прогонами</div></div>
      </div>
      <p class="why"><b>То, что вы слышали на занятии 7</b> &nbsp;Агент с каждым сообщением перечитывает всю беседу. Поэтому одно задание - одна беседа, а работа, которую может сделать скрипт, не должна каждый раз стоить просьбы.</p>''', '''
      <p class="timing">РЕЗЕРВ &middot; на вопрос «а сколько это стоит?»</p>
      <p><strong>Честно о границе замера:</strong> посчитаны только беседы, начатые из папки сайта курса, с 13 ноября. Раньше сайт строился из других бесед, и они сюда не вошли.</p>
      <div class="cockpit"><p><strong>Источники:</strong> транскрипты <code>~/.claude/projects/*b1bootcamp26*</code>, каждое сообщение один раз: 54,1 млн токенов, из них чтение кэша 52,0 млн; прогоны на Sonnet - 1,8 млн. 4% - экран <code>/usage</code> тренера в конце дня 24 ноября, после пополнения лимита утром.</p></div>''')

slide("Резерв &middot; Ворота", "ext", '''
      <p class="eyebrow">Резерв &middot; ворота deploy.sh</p>
      <h2 class="head">Четыре прогона ворот -<br><span class="brass">четыре находки</span>.</h2>
      <div class="quotes">
        <div class="q"><b>прогон 1</b>Скрипт не закоммичен, и откат убрал сам скрипт вместо поломки.</div>
        <div class="q"><b>прогон 2</b>Нет свежего main с GitHub: локальный main уходил вперёд.</div>
        <div class="q steel"><b>прогон 3</b>Русское имя переменной: bash его не понимает.</div>
        <div class="q steel"><b>прогон 4</b>На красном вывод проверки был спрятан: не видно, что сломано.</div>
      </div>
      <p class="why"><b>Итог</b> &nbsp;Красное не публикуется. Но ворота ручные: обычный git push их обходит, и страница говорит это прямо.</p>''', '''
      <p class="timing">РЕЗЕРВ &middot; на вопрос «а что такое ворота выпуска?»</p>
      <div class="cockpit"><p><strong>Источники:</strong> «Ворота прогонялись четыре раза» в <code>zapis-7.md</code>; шаг <code>07.html#max-1</code>.</p></div>''')

slide("Резерв &middot; Испытание", "ext", '''
      <p class="eyebrow steel">Резерв &middot; испытание, которое ничего не испытало</p>
      <h2 class="head">Ссылки нет,<br>а проверка <span class="brass">зелёная</span>.</h2>
      <p class="lede">Второй прогон деки сдачи. Адрес репозитория стоял в деке дважды: в ссылке и в тексте. Агент убрал одно вхождение и запустил проверку.</p>
      <div class="out">8.3 в деке есть ссылка на мой репозиторий &nbsp;<span class="g">ДА</span> &nbsp;&middot;&nbsp; <span class="g">ЗЕЛЁНОЕ</span></div>
      <div class="out">адрес убран везде: 8.3 <span class="r">НЕТ</span> &nbsp;&middot;&nbsp; <span class="r">КРАСНОЕ</span> &nbsp;&rarr;&nbsp; после git checkout <span class="g">ЗЕЛЁНОЕ</span></div>
      <p class="why"><b>Урок занятия 7, ещё раз</b> &nbsp;Испытание тоже можно провести так, что оно ничего не проверит. Нашёл это субагент до вас, а не вы на занятии. Промпт теперь велит убрать адрес «везде, где он есть».</p>''', '''
      <p class="timing">РЕЗЕРВ &middot; на вопрос «а субагент правда что-то находит?»</p>
      <div class="cockpit"><p><strong>Источники:</strong> «Второй прогон нашёл дыру в испытании» в <code>zapis-8.md</code>; промпт <code>08.html#min-3</code>.</p></div>''')

slide("Резерв &middot; Ветки", "ext", '''
      <p class="eyebrow">Резерв &middot; самое хрупкое место</p>
      <h2 class="head">Ветки и пул-реквесты -<br><span class="brass">новое и хрупкое</span>.</h2>
      <div class="prompt"><span class="who">промпт на занятии 7</span>Переключись в ветку main и потяни изменения сайта.</div>
      <p class="lede">Ветку для задания 6 завели, а само задание отправили в main. Такое случается не только с учениками.</p>
      <p class="why"><b>Почему пары собирались небыстро</b> &nbsp;Пригласить напарника, завести ветку, прислать пул-реквест, влить - четыре новых действия сразу. Зато всё получилось.</p>''', '''
      <p class="timing">РЕЗЕРВ &middot; на вопрос «почему обмен в парах шёл медленно?»</p>
      <div class="cockpit"><p><strong>Источники:</strong> занятие 7, 2026-11-28, три пары; схема веток - <code>06.html</code> и <code>zapis-6.md</code>.</p></div>''')

slide("Резерв &middot; Оркестр", "ext", f'''
      <p class="eyebrow steel">Резерв &middot; кто что делал</p>
      <h2 class="head">Дирижёр <span class="brass">решает</span>,<br>пилот исполняет.</h2>
      {flow([("дирижёр","тренер: задание, приёмка, git push"),("пилот","ИИ: страница, проверка, запись, коммит"),("субагент","первый ученик: прогон промптов")], accent=(0,))}
      <div class="cols three">
        <div class="card"><p class="k">правило</p><h3>Пушит только человек</h3><p>ИИ коммитит у себя и останавливается. На GitHub работу отправляет тренер, после приёмки.</p></div>
        <div class="card"><p class="k">правило</p><h3>ИИ - не соавтор</h3><p>В коммитах нет строки «соавтор ИИ». Исполнитель - не автор.</p></div>
        <div class="card steel"><p class="k">правило</p><h3>Детей в репозитории нет</h3><p>Ни на сайте, ни в записях нет фактов о группе: кто что сделал и сколько справилось.</p></div>
      </div>''', '''
      <p class="timing">РЕЗЕРВ &middot; на вопрос «а ИИ сам всё делал?»</p>
      <p><strong>Сказать:</strong> «Нет. ИИ делал много и быстро, но каждое "сделано" принимал человек, по предикатам».</p>
      <div class="cockpit"><p><strong>Источники:</strong> правило запрета пуша - <code>CLAUDE.md</code> фабрики; приёмки - разделы «Приёмка» в записях.</p></div>''')

RESERVE_ORDER = ["Испытание", "Ворота", "Цена", "Программа", "Ветки", "Занятия", "Оркестр"]
_core = [x for x in SL if x[1] == "core"]
_ext = {x[0].split("&middot; ")[1]: x for x in SL if x[1] == "ext"}
assert sorted(_ext) == sorted(RESERVE_ORDER), sorted(_ext)
SL = _core + [_ext[k] for k in RESERVE_ORDER]

assemble(SRC, OUT, "ru", "AI Bootcamp: как мы делали курс", SL, brand="AI <b>//</b> BOOTCAMP", core_min=10, extra_css=CSS)

# Надписи старого движка: у нас не «полная дека» и «расширение», а ядро и резерв.
doc = open(OUT, encoding="utf-8").read()
for a, b in (('content: "расширение";', 'content: "резерв";'),
             ("tierMark.textContent = tier === 'full' ? 'ПОЛНАЯ' : 'ЯДРО';", "tierMark.textContent = tier === 'full' ? 'РЕЗЕРВ' : 'ЯДРО';")):
    assert doc.count(a) == 1, a
    doc = doc.replace(a, b)
open(OUT, "w", encoding="utf-8").write(doc)
