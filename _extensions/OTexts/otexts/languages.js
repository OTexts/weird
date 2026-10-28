// Language selector in the sidebar, between the book title and the search box.
// The editions come from the `languages:` metadata (written to the page by
// otexts.lua). All editions share file names and anchors, so choosing one
// opens the same page there, at the section, figure or table being read.
//
// Above it, R and Python icons link the R and Python versions of the book (the
// `software:` metadata): this one in bold, the other faint. Their page names
// differ, so the other's `pages:` maps this book's pages onto its own
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
    const name = page();
    const mapped = edition.pages ? edition.pages[name.replace(/\.html$/, "")] : name;
    // A page with no counterpart goes to the home page (the preface)
    if (mapped === undefined) {
      window.location.href = base;
      return;
    }
    const target = new URL(mapped && edition.pages ? mapped + ".html" : mapped, base).href;
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

  const insertLanguages = (sidebar) => {
    const config = document.getElementById("otexts-languages");
    if (!config) return;
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
    place(sidebar, box);
  };

  // Font Awesome Free 6.1.1 brand icons (CC BY 4.0), https://fontawesome.com
  const logos = {
    r: {
      viewBox: "0 0 581 512",
      d: "M581 226.6C581 119.1 450.9 32 290.5 32S0 119.1 0 226.6C0 322.4 103.3 402 239.4 418.1V480h99.1v-61.5c24.3-2.7 47.6-7.4 69.4-13.9L448 480h112l-67.4-113.7c54.5-35.4 88.4-84.9 88.4-139.7zm-466.8 14.5c0-73.5 98.9-133 220.8-133s211.9 40.7 211.9 133c0 50.1-26.5 85-70.3 106.4-2.4-1.6-4.7-2.9-6.4-3.7-10.2-5.2-27.8-10.5-27.8-10.5s86.6-6.4 86.6-92.7-90.6-87.9-90.6-87.9h-199V361c-74.1-21.5-125.2-67.1-125.2-119.9zm225.1 38.3v-55.6c57.8 0 87.8-6.8 87.8 27.3 0 36.5-38.2 28.3-87.8 28.3zm-.9 72.5H365c10.8 0 18.9 11.7 24 19.2-16.1 1.9-33 2.8-50.6 2.9v-22.1z",
    },
    python: {
      viewBox: "0 0 448 512",
      d: "M439.8 200.5c-7.7-30.9-22.3-54.2-53.4-54.2h-40.1v47.4c0 36.8-31.2 67.8-66.8 67.8H172.7c-29.2 0-53.4 25-53.4 54.3v101.8c0 29 25.2 46 53.4 54.3 33.8 9.9 66.3 11.7 106.8 0 26.9-7.8 53.4-23.5 53.4-54.3v-40.7H226.2v-13.6h160.2c31.1 0 42.6-21.7 53.4-54.2 11.2-33.5 10.7-65.7 0-108.6zM286.2 404c11.1 0 20.1 9.1 20.1 20.3 0 11.3-9 20.4-20.1 20.4-11 0-20.1-9.2-20.1-20.4.1-11.3 9.1-20.3 20.1-20.3zM167.8 248.1h106.8c29.7 0 53.4-24.5 53.4-54.3V91.9c0-29-24.4-50.7-53.4-55.6-35.8-5.9-74.7-5.6-106.8.1-45.2 8-53.4 24.7-53.4 55.6v40.7h106.9v13.6h-147c-31.1 0-58.3 18.7-66.8 54.2-9.8 40.7-10.2 66.1 0 108.6 7.6 31.6 25.7 54.2 56.8 54.2H101v-48.8c0-35.3 30.5-66.4 66.8-66.4zm-6.7-142.6c-11.1 0-20.1-9.1-20.1-20.3.1-11.3 9-20.4 20.1-20.4 11 0 20.1 9.2 20.1 20.4s-9 20.3-20.1 20.3z",
    },
  };

  const insertSoftware = (sidebar) => {
    const config = document.getElementById("otexts-software");
    if (!config) return;
    const books = JSON.parse(config.textContent);
    const box = document.createElement("div");
    box.className = "otexts-software";
    books.forEach((b) => {
      const logo = logos[b.lang.toLowerCase()];
      if (!logo) return;
      const svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
      svg.setAttribute("viewBox", logo.viewBox);
      svg.setAttribute("aria-hidden", "true");
      const path = document.createElementNS("http://www.w3.org/2000/svg", "path");
      path.setAttribute("d", logo.d);
      svg.append(path);
      const el = document.createElement(b.current ? "span" : "a");
      el.className = "otexts-software-" + b.lang.toLowerCase();
      el.setAttribute("aria-label", b.name);
      el.title = b.current ? b.name + " (this book)" : "Read the " + b.name + " version";
      if (b.current) {
        el.classList.add("current");
        el.setAttribute("aria-current", "true");
      } else {
        el.href = b.url;
        el.addEventListener("click", (event) => {
          event.preventDefault();
          go(b);
        });
      }
      el.append(svg);
      box.append(el);
    });
    if (box.children.length) place(sidebar, box);
  };

  const place = (sidebar, box) => {
    const header = sidebar.querySelector(".sidebar-header");
    if (header) header.after(box);
    else sidebar.prepend(box);
  };

  // The software icons go last so that they land above the language selector
  const insert = () => {
    const sidebar = document.getElementById("quarto-sidebar");
    if (!sidebar) return;
    insertLanguages(sidebar);
    insertSoftware(sidebar);
  };

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", insert);
  } else {
    insert();
  }
})();
