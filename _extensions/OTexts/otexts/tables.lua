-- Page breaks in tables in the PDF. Tables that aren't floats are longtables,
-- which break anywhere, even straight after the caption and header. Start a new
-- page unless there is room for the whole table, or for the first few rows of
-- a table too long to be worth keeping whole. Runs after Quarto has added the
-- captions, when a captioned table has become raw blocks between
-- \begin{longtable} and \end{longtable}.
local MAX_WHOLE_ROWS = 30
local MIN_ROWS = 6
local CHARS_PER_LINE = 70

local function needspace(rows, caption_chars)
  if rows > MAX_WHOLE_ROWS then rows = MIN_ROWS end
  -- Plus the header, rules and space around the table
  local lines = rows + 3 + math.ceil(caption_chars / CHARS_PER_LINE)
  -- \Needspace* measures the space left; \needspace's penalty can break the
  -- page early even when the table fits
  return pandoc.RawBlock("latex", "\\Needspace*{" .. lines .. "\\baselineskip}")
end

local function is_raw(block, pattern)
  return block.t == "RawBlock" and block.format:match("latex") and block.text:find(pattern)
end

-- Rows and caption length of the LaTeX from a captioned table
local function raw_table_size(blocks)
  local latex = pandoc.write(pandoc.Pandoc(blocks), "latex")
  local _, rows = latex:gsub("\\\\%s*\n", "")
  local caption = latex:match("\\caption(%b{})") or ""
  return rows, #caption
end

function Blocks(blocks)
  local out = pandoc.Blocks({})
  local i = 1
  while i <= #blocks do
    if is_raw(blocks[i], "\\begin{longtable}") then
      local inner = pandoc.Blocks({})
      local j = i + 1
      while j <= #blocks and not is_raw(blocks[j], "\\end{longtable}") do
        inner:insert(blocks[j])
        j = j + 1
      end
      out:insert(needspace(raw_table_size(inner)))
    end
    out:insert(blocks[i])
    i = i + 1
  end
  return out
end

function Table(el)
  local rows = 0
  for _, body in ipairs(el.bodies) do rows = rows + #body.body end
  return { needspace(rows, #pandoc.utils.stringify(el.caption.long or {})), el }
end
