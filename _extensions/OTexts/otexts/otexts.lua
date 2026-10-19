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

function Meta(meta)
  if quarto.doc.is_format("html") then
    quarto.doc.add_html_dependency({
      name = "otexts-fonts",
      version = "0.1.0",
      stylesheets = { "fonts.css" },
      resources = resources,
    })
  end
  return meta
end

-- Mark [-@sec-...] refs so htmlreplace.pl can drop the "Chapter" prefix: on
-- unnumbered pages (e.g. the preface) Quarto ignores the "-" and gives the
-- full chapter title, which htmlreplace.pl would turn into "Chapter N"
function Cite(cite)
  local c = cite.citations[1]
  if #cite.citations == 1 and c.mode == "SuppressAuthor" and c.id:match("^sec%-") then
    return pandoc.Span(cite, { class = "xref-noprefix" })
  end
end
