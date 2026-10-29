-- Add the self-hosted fonts (fonts.css and fonts/) to each HTML page
local fonts = {
  "Libron-Regular", "Libron-Italic", "Libron-Bold", "Libron-BoldItalic",
  "hack-regular-subset", "hack-bold-subset", "hack-italic-subset",
  "hack-bolditalic-subset",
}
for _, subset in ipairs({ "latin", "latin-ext" }) do
  for _, face in ipairs({ "400-normal", "400-italic", "600-normal", "700-normal",
    "700-italic" }) do
    table.insert(fonts, "fira-sans-" .. subset .. "-" .. face)
  end
end

local resources = {}
for _, font in ipairs(fonts) do
  table.insert(resources, { name = "fonts/" .. font .. ".woff2",
    path = "fonts/" .. font .. ".woff2" })
end

-- Write a list of metadata items into the page as JSON, for languages.js
local function add_json(id, items)
  local json = quarto.json.encode(items):gsub("</", "<\\/")
  quarto.doc.include_text("in-header",
    '<script type="application/json" id="' .. id .. '">' .. json .. "</script>")
end

-- Language selector: the `languages:` list (lang, name, url of each edition)
local function add_languages(languages)
  if not languages or #languages == 0 then return false end
  local editions = {}
  for _, l in ipairs(languages) do
    table.insert(editions, {
      lang = pandoc.utils.stringify(l.lang),
      name = pandoc.utils.stringify(l.name),
      url = pandoc.utils.stringify(l.url),
    })
  end
  add_json("otexts-languages", editions)
  return true
end

-- R and Python icons: the `software:` list (lang, name, url, and for the
-- current book `current: true`). `pages` maps this book's page names to the
-- other book's, e.g. intro: 01-intro
local function add_software(software)
  if not software or #software == 0 then return false end
  local books = {}
  for _, s in ipairs(software) do
    local book = {
      lang = pandoc.utils.stringify(s.lang),
      name = pandoc.utils.stringify(s.name),
      url = pandoc.utils.stringify(s.url),
      current = s.current == true,
    }
    if s.pages then
      book.pages = {}
      for key, value in pairs(s.pages) do
        book.pages[key] = pandoc.utils.stringify(value)
      end
    end
    table.insert(books, book)
  end
  add_json("otexts-software", books)
  return true
end

-- Front page cover: `::: {.otexts-cover image="..."}` puts the book cover
-- beside the div's content, which ends with the page's date-modified. Without
-- an image, a stand-in cover is drawn in CSS from the title and authors,
-- with the optional `logo="..."` image (e.g. a hex sticker) below the title
local function author_names(meta)
  local names = pandoc.List({})
  for _, a in ipairs(meta["by-author"] or {}) do
    local name = a.name and a.name.literal or a.name
    names:insert(pandoc.utils.stringify(name or ""))
  end
  if #names < 2 then return names[1] or "" end
  return table.concat(names, ", ", 1, #names - 1) .. " and " .. names[#names]
end

-- The image is the div's `image`, else `book: cover-image` if the file exists
local function cover_image(div, meta)
  if div.attributes.image then return div.attributes.image end
  local image = meta.book and meta.book["cover-image"]
  image = image and pandoc.utils.stringify(image)
  if image and image ~= "" then
    local f = io.open(image, "r")
    if f then
      f:close()
      return image
    end
  end
end

local function cover_book(div, meta)
  local image = cover_image(div, meta)
  if image then
    local alt = div.attributes.alt
    if not alt then
      alt = "Front cover of " .. pandoc.utils.stringify(meta.title or "")
      local names = author_names(meta)
      if names ~= "" then alt = alt .. ", by " .. names end
    end
    return pandoc.Div(pandoc.Plain(pandoc.Image(alt, image)),
      { class = "otexts-cover-book" })
  end
  local authors = pandoc.Inlines({})
  for i, a in ipairs(meta["by-author"] or {}) do
    if i > 1 then authors:insert(pandoc.LineBreak()) end
    local name = a.name and a.name.literal or a.name
    authors:extend(pandoc.Inlines(name or {}))
  end
  local parts = {
    pandoc.Div(pandoc.Plain(authors), { class = "otexts-cover-authors" }),
    pandoc.Div(pandoc.Plain(meta.title or {}), { class = "otexts-cover-title" }),
  }
  if div.attributes.logo then
    parts[#parts + 1] = pandoc.Div(pandoc.Plain(pandoc.Image("", div.attributes.logo)),
      { class = "otexts-cover-logo" })
  end
  parts[#parts + 1] = pandoc.Div(pandoc.Plain("OTexts"), { class = "otexts-cover-publisher" })
  return pandoc.Div(parts, { class = "otexts-cover-book otexts-cover-standin", ["aria-hidden"] = "true" })
end

local function cover(div, meta)
  local text = pandoc.Blocks(div.content)
  if meta["date-modified"] then
    local label = pandoc.utils.stringify(meta["published-title"] or "Last updated")
    text:insert(pandoc.Div(pandoc.Plain(label .. " " ..
      pandoc.utils.stringify(meta["date-modified"])), { class = "otexts-cover-updated" }))
  end
  return pandoc.Div({
    cover_book(div, meta),
    pandoc.Div(text, { class = "otexts-cover-text" }),
  }, { class = "otexts-cover" })
end

-- The cover is for the web book only: in other formats it is dropped, with
-- the page's heading (Quarto lifts a chapter's first heading out of any div,
-- so the heading can't be hidden with .content-visible). Other blocks, such as
-- the Jupyter engine's front matter cell, can sit between the two
local function drop_cover(blocks)
  local kept = pandoc.Blocks({})
  for _, block in ipairs(blocks) do
    if block.t == "Div" and block.classes:includes("otexts-cover") then
      for i = #kept, 1, -1 do
        if kept[i].t == "Header" then
          if kept[i].level == 1 then kept:remove(i) end
          break
        end
      end
    else
      kept:insert(block)
    end
  end
  return kept
end

function Pandoc(doc)
  if not quarto.doc.is_format("html") then
    doc.blocks = drop_cover(doc.blocks)
    return doc
  end
  doc.blocks = doc.blocks:walk({
    Div = function(div)
      if div.classes:includes("otexts-cover") then return cover(div, doc.meta) end
    end,
  })
  return doc
end

function Meta(meta)
  if quarto.doc.is_format("html") then
    quarto.doc.add_html_dependency({
      name = "otexts-fonts",
      version = "0.1.0",
      stylesheets = { "fonts.css" },
      resources = resources,
    })
    local has_languages = add_languages(meta.languages)
    local has_software = add_software(meta.software)
    if has_languages or has_software then
      quarto.doc.add_html_dependency({
        name = "otexts-languages",
        version = "0.1.0",
        scripts = { "languages.js" },
      })
    end
  end
  return meta
end

-- Mark [-@sec-...] refs so htmlreplace.pl can drop the "Chapter" prefix: on
-- unnumbered pages (e.g. the preface) Quarto ignores the "-" and gives the
-- full chapter title, which htmlreplace.pl would turn into "Chapter N"
function Cite(cite)
  if not quarto.doc.is_format("html") then return nil end
  local c = cite.citations[1]
  if #cite.citations == 1 and c.mode == "SuppressAuthor" and c.id:match("^sec%-") then
    return pandoc.Span(cite, { class = "xref-noprefix" })
  end
end
