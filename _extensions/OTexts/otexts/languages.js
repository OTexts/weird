// Language selector in the sidebar, between the book title and the search box.
// The editions come from the `languages:` metadata (written to the page by
// otexts.lua). All editions share file names and anchors, so choosing one
// opens the same page there, at the section, figure or table being read
(() => {
  // The page's path within the book, from Quarto's offset to the book root
  const page = () => {
    const offset = document.querySelector('meta[name="quarto:offset"]');
    const root = new URL(offset ? offset.content : "./", window.location.href);
    const path = decodeURI(window.location.pathname);
    const rootPath = decodeURI(root.pathname);
    const rel = path.startsWith(rootPath) ? path.slice(rootPath.length) : "";
    return rel.replace(/(^|\/)index\.html$/, "$1");
  };

  // The last section, figure or table starting above the top of the window
  const anchor = () => {
    const top = 80;
    let id = "";
    document
      .querySelectorAll('main section[id], main div[id^="fig-"], main div[id^="tbl-"]')
      .forEach((el) => {
        if (el.getClientRects().length && el.getBoundingClientRect().top <= top) id = el.id;
      });
    return id ? "#" + id : "";
  };

  const go = async (edition) => {
    const base = edition.url.replace(/\/?$/, "/");
    const target = new URL(page(), base).href;
    // Fall back to the edition's home page if it lacks this page. Another
    // origin gives an opaque response, so then just go
    try {
      const res = await fetch(target, { method: "HEAD", mode: "no-cors" });
      if (res.type !== "opaque" && !res.ok) {
        window.location.href = base;
        return;
      }
    } catch (e) {}
    window.location.href = target + anchor();
  };

  const insert = () => {
    const config = document.getElementById("otexts-languages");
    const sidebar = document.getElementById("quarto-sidebar");
    if (!config || !sidebar) return;
    const editions = JSON.parse(config.textContent);
    if (editions.length < 2) return;

    // This edition: an exact lang match, else the same primary language
    // (Quarto writes lang: zh as zh-Hans)
    const htmlLang = (document.documentElement.lang || "en").toLowerCase();
    const current =
      editions.find((e) => e.lang.toLowerCase() === htmlLang) ||
      editions.find((e) => e.lang.toLowerCase() === htmlLang.split("-")[0]);

    const box = document.createElement("div");
    box.className = "otexts-languages";
    const icon = document.createElement("i");
    icon.className = "bi bi-translate";
    icon.setAttribute("aria-hidden", "true");
    const select = document.createElement("select");
    select.setAttribute("aria-label", "Language");
    editions.forEach((e, i) => {
      const option = new Option(e.name, i, false, e === current);
      option.lang = e.lang;
      select.add(option);
    });
    if (!current) select.selectedIndex = -1;
    select.addEventListener("change", () => go(editions[select.value]));
    box.append(icon, select);
    const header = sidebar.querySelector(".sidebar-header");
    if (header) header.after(box);
    else sidebar.prepend(box);
  };

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", insert);
  } else {
    insert();
  }
})();
