"""Copied 2026-11-28 from docs/implementation/talkaos/deck/builder, with a "ru" entry added, so the course deck builds on its own.

Assemble a deck: engine (CSS, JS, frame) from an existing deck, slides from the caller."""
import re, html
E = html.escape

def must(text, old, new, n=1):
    c = text.count(old)
    assert c == n, (old[:70], c)
    return text.replace(old, new)

def excerpt(src, verify, code, cls=""):
    c = f' class="{cls}"' if cls else ''
    return f'''<div class="excerpt">
        <div class="srcbar"><span>{src}</span><span class="verify">{verify}</span></div>
<pre{c}>{code}</pre>
      </div>'''

UI = {
 "ru": dict(
   all_old="'Показаны <b>все 19 слайдов</b>. Клавиша <b>C</b> переключает на ядро из 11.'",
   all_new="'Показаны <b>все слайды ({N})</b>. Клавиша <b>C</b> прячет резерв.'",
   core_old="'Показано <b>ядро из 11 слайдов</b>. Слайды расширения вынуты из деки. Клавиша <b>C</b> возвращает их.'",
   core_new="'Показано <b>ядро из {C} слайдов</b>. Клавиша <b>C</b> открывает резерв для вопросов.'",
   tf_old="'Полная: 19 слайдов, 45 минут'", tf_new="'Резерв открыт: все слайды ({N})'",
   tc_old="'Ядро: 11 слайдов, 20-25 минут'", tc_new="'Ядро: {C} слайдов, {M} минут'",
   btn_js_old="btnTier.textContent = tier === 'full' ? 'Ядро' : 'Полная';",
   btn_js_new="btnTier.textContent = tier === 'full' ? 'Ядро' : 'Резерв';",
   mark_old='<span class="tiermark" id="tierMark">ПОЛНАЯ</span>', mark_new='<span class="tiermark" id="tierMark">ЯДРО</span>',
   sec_old='<div class="section" id="sectionLabel">О докладе</div>',
   btn_old='<button id="btnTier" aria-pressed="false">Ядро</button>', btn_new='<button id="btnTier" aria-pressed="true">Резерв</button>',
   key_old='<span><kbd>C</kbd> ядро</span>', key_new='<span><kbd>C</kbd> резерв</span>',
   title_old="<title>От чата к фабрике</title>"),
 "uk": dict(
   all_old="'Показано <b>всі 19 слайдів</b>. Клавіша <b>C</b> переключає на ядро з 11.'",
   all_new="'Показано <b>усі слайди ({N})</b>. Клавіша <b>C</b> ховає резерв.'",
   core_old="'Показано <b>ядро з 11 слайдів</b>. Слайди розширення вийняті з колоди. Клавіша <b>C</b> повертає їх.'",
   core_new="'Показано <b>ядро з {C} слайдів</b>. Клавіша <b>C</b> відкриває резерв до запитань.'",
   tf_old="'Повна: 19 слайдів, 45 хвилин'", tf_new="'Резерв відкрито: усі слайди ({N})'",
   tc_old="'Ядро: 11 слайдів, 20-25 хвилин'", tc_new="'Ядро: {C} слайдів, {M} хвилин'",
   btn_js_old="btnTier.textContent = tier === 'full' ? 'Ядро' : 'Повна';",
   btn_js_new="btnTier.textContent = tier === 'full' ? 'Ядро' : 'Резерв';",
   mark_old='<span class="tiermark" id="tierMark">ПОВНА</span>', mark_new='<span class="tiermark" id="tierMark">ЯДРО</span>',
   sec_old='<div class="section" id="sectionLabel">Про доповідь</div>',
   btn_old='<button id="btnTier" aria-pressed="false">Ядро</button>', btn_new='<button id="btnTier" aria-pressed="true">Резерв</button>',
   key_old='<span><kbd>C</kbd> ядро</span>', key_new='<span><kbd>C</kbd> резерв</span>',
   title_old="<title>Від чату до фабрики</title>"),
 "en": dict(
   all_old="'Showing <b>all 19 slides</b>. Press <b>C</b> to switch to the 11-slide core.'",
   all_new="'Showing <b>all {N} slides</b>. Press <b>C</b> to hide the reserve.'",
   core_old="'Showing the <b>11-slide core</b>. Extended slides are out of the deck. Press <b>C</b> to bring them back.'",
   core_new="'Showing the <b>{C}-slide core</b>. Press <b>C</b> to open the reserve for questions.'",
   tf_old="'Full: 19 slides, 45 min'", tf_new="'Reserve open: {N} slides'",
   tc_old="'Core: 11 slides, 20-25 min'", tc_new="'Core: {C} slides, {M} min'",
   btn_js_old="btnTier.textContent = tier === 'full' ? 'Core' : 'Full';",
   btn_js_new="btnTier.textContent = tier === 'full' ? 'Core' : 'Reserve';",
   mark_old='<span class="tiermark" id="tierMark">FULL</span>', mark_new='<span class="tiermark" id="tierMark">CORE</span>',
   sec_old='<div class="section" id="sectionLabel">About</div>',
   btn_old='<button id="btnTier" aria-pressed="false">Core</button>', btn_new='<button id="btnTier" aria-pressed="true">Reserve</button>',
   key_old='<span><kbd>C</kbd> core/full</span>', key_new='<span><kbd>C</kbd> reserve</span>',
   title_old="<title>Agents on a Bus</title>"),
}

EXTRA_CSS = """
  .chainrow { margin-top: 14px; }
  .chainrow > .k { font-family: var(--font-mono); font-size: 12.5px; letter-spacing: .06em; text-transform: uppercase; color: var(--muted); margin: 0 0 6px; }
  .excerpt pre.tight { font-size: clamp(12.5px, 1.2vw, 15px); }
  .ladder { display: grid; grid-template-columns: repeat(4, 1fr); gap: 14px; margin-top: 18px; align-items: start; }
  .ladder .card:nth-child(1) { margin-top: 84px; }
  .ladder .card:nth-child(2) { margin-top: 56px; }
  .ladder .card:nth-child(3) { margin-top: 28px; }
  .ladder .n { font-family: var(--font-mono); font-size: 30px; line-height: 1; color: var(--accent); margin: 0 0 6px; }
  .ladder .card.steel .n { color: var(--steel); }
  .ladder .tools { font-size: 13px; color: var(--muted); }
  .ladder .g { margin-top: 10px; font-family: var(--font-mono); font-size: 13px; color: var(--ink); }
  @media (max-width: 900px) { .ladder { grid-template-columns: 1fr; } .ladder .card { margin-top: 0 !important; } }
  .excerpt pre.graph { font-size: clamp(11.5px, 1.08vw, 14px); line-height: 1.36; padding: 10px 16px; }
"""

def assemble(src, out, lang, title, slides, brand="AGENTIC <b>//</b> OS", core_min=20, extra_css=""):
    """brand, core_min and extra_css default to the Agentic OS decks (talkaos); talkcac passes its own."""
    s = open(src, encoding="utf-8").read()
    u = UI[lang]
    css = re.search(r'<style>(.*?)</style>', s, re.S).group(1)
    js = re.search(r'<script>(.*?)</script>', s, re.S).group(1)
    css = must(css, "font-size: clamp(11.5px, 1.18vw, 14px); line-height: 1.52;", "font-size: clamp(14px, 1.45vw, 17.5px); line-height: 1.5;")
    css, k = re.subn(r"(\.excerpt \.srcbar \{[^}]*?font-size: )11\.5px", r"\g<1>13px", css, count=1)
    assert k == 1, "srcbar font-size"
    css += EXTRA_CSS + extra_css
    js = must(js, "var tier = 'full';", "var tier = 'core';")
    N = len(slides); C = sum(1 for x in slides if x[1] == "core")
    for a, b in (("all_old","all_new"),("core_old","core_new"),("tf_old","tf_new"),("tc_old","tc_new"),("btn_js_old","btn_js_new")):
        js = must(js, u[a], u[b].replace("{N}", str(N)).replace("{C}", str(C)).replace("{M}", str(core_min)))
    head = must(s[:s.find('<style>')], u["title_old"], f"<title>{title}</title>")
    top = s[s.find('</style>')+len('</style>'):s.find('<section class="slide')]
    top = re.sub(r'<div class="brand">.*?</div>', f'<div class="brand">{brand}</div>', top, count=1)
    top = must(top, u["mark_old"], u["mark_new"])
    top = must(top, '<span id="idxTotal">19</span>', f'<span id="idxTotal">{C}</span>')
    top = must(top, u["sec_old"], f'<div class="section" id="sectionLabel">{slides[0][0]}</div>')
    top = re.sub(r'<!--.*?-->\s*$', '', top, flags=re.S)
    last = s.rfind('</section>') + len('</section>')
    bot = s[last:s.find('<script>')]
    bot = must(bot, u["btn_old"], u["btn_new"]); bot = must(bot, u["key_old"], u["key_new"])
    parts = []
    for i, (sec, tier, body, notes) in enumerate(slides):
        cls = "slide title-slide is-active" if i == 0 else "slide"
        parts.append(f'''  <section class="{cls}" data-section="{sec}" data-tier="{tier}">
    <div class="wrap">{body}
    </div>
    <div class="notes">{notes}
    </div>
  </section>
''')
    doc = head + "<style>" + css + "</style>" + top + "\n" + "".join(parts) + bot + "<script>" + js + "</script>" + s[s.find('</script>')+len('</script>'):]
    assert "—" not in doc, "em-dash present"
    open(out, "w", encoding="utf-8").write(doc)
    print("wrote", out, len(doc), "chars;", N, "slides,", C, "core,", N - C, "reserve")
