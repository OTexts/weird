-- Page breaks in code and output blocks in the PDF. A code block of at most
-- MAX_CODE_LINES lines, or an output block of at most MAX_OUTPUT_LINES lines,
-- goes in a minipage, which TeX can't split. A longer code block may break
-- across pages only between commands (\otextscodebreaks in fpp.sty), or
-- inside a command too long to fit on a page. Longer output is left to break
-- wherever it falls.
local MAX_CODE_LINES = 4
local MAX_OUTPUT_LINES = 16
local PAGE_LINES = 40

local function wrap(text, el)
  local cb = pandoc.CodeBlock(text, pandoc.Attr("", el.classes, el.attributes))
  return {
    pandoc.RawBlock("latex", "\\begin{minipage}{\\linewidth}"),
    cb,
    pandoc.RawBlock("latex", "\\end{minipage}"),
  }
end

-- Split the lines of R code into commands: a command ends at a line where all
-- brackets and strings are closed and no operator is left dangling
local function commands(lines)
  local out, cur = {}, {}
  local depth, quote = 0, nil
  for _, line in ipairs(lines) do
    cur[#cur + 1] = line
    local i, n, code_end = 1, #line, 0
    while i <= n do
      local c = line:sub(i, i)
      if quote then
        if c == "\\" then i = i + 1
        elseif c == quote then quote = nil end
        code_end = i
      elseif c == "#" then
        break
      else
        if c == '"' or c == "'" or c == "`" then quote = c
        elseif c == "(" or c == "[" or c == "{" then depth = depth + 1
        elseif c == ")" or c == "]" or c == "}" then depth = depth - 1 end
        if not c:match("%s") then code_end = i end
      end
      i = i + 1
    end
    local code = line:sub(1, code_end)
    local dangling = code:match("[%%|&+%-*/,=~<>!^:]$") ~= nil
    if depth <= 0 and not quote and not dangling then
      out[#out + 1] = cur
      cur, depth = {}, 0
    end
  end
  if #cur > 0 then out[#out + 1] = cur end
  return out
end

function CodeBlock(el)
  local lines = {}
  for line in (el.text .. "\n"):gmatch("(.-)\n") do lines[#lines + 1] = line end
  local is_code = el.classes:includes("r") or el.classes:includes("sourceCode")
  if #lines <= (is_code and MAX_CODE_LINES or MAX_OUTPUT_LINES) then
    return wrap(el.text, el)
  end
  if not is_code then return nil end
  local breaks, n = {}, 0
  for _, cmd in ipairs(commands(lines)) do
    if #cmd > PAGE_LINES then
      for k = n + 1, n + #cmd - 1 do breaks[#breaks + 1] = k end
    end
    n = n + #cmd
    -- A comment stays with the command after it
    local comment = cmd[#cmd]:match("^%s*#") ~= nil
    if n < #lines and not comment then breaks[#breaks + 1] = n end
  end
  return {
    pandoc.RawBlock("latex", "\\otextscodebreaks{" .. table.concat(breaks, ",") .. "}"),
    el,
    pandoc.RawBlock("latex", "\\otextscodebreaksoff"),
  }
end

-- A little space between a chunk's code and its output
function Div(el)
  if el.classes:includes("cell-output") and not el.classes:includes("cell-output-display") then
    el.content:insert(1, pandoc.RawBlock("latex", "\\vspace{0.4\\baselineskip}"))
    return el
  end
end
