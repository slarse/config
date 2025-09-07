--- This code is vendored from https://github.com/uga-rosa/utf8.nvim
---
--- Creative Commons Legal Code
--- 
--- CC0 1.0 Universal
--- 
---     CREATIVE COMMONS CORPORATION IS NOT A LAW FIRM AND DOES NOT PROVIDE
---     LEGAL SERVICES. DISTRIBUTION OF THIS DOCUMENT DOES NOT CREATE AN
---     ATTORNEY-CLIENT RELATIONSHIP. CREATIVE COMMONS PROVIDES THIS
---     INFORMATION ON AN "AS-IS" BASIS. CREATIVE COMMONS MAKES NO WARRANTIES
---     REGARDING THE USE OF THIS DOCUMENT OR THE INFORMATION OR WORKS
---     PROVIDED HEREUNDER, AND DISCLAIMS LIABILITY FOR DAMAGES RESULTING FROM
---     THE USE OF THIS DOCUMENT OR THE INFORMATION OR WORKS PROVIDED
---     HEREUNDER.
--- 
--- Statement of Purpose
--- 
--- The laws of most jurisdictions throughout the world automatically confer
--- exclusive Copyright and Related Rights (defined below) upon the creator
--- and subsequent owner(s) (each and all, an "owner") of an original work of
--- authorship and/or a database (each, a "Work").
--- 
--- Certain owners wish to permanently relinquish those rights to a Work for
--- the purpose of contributing to a commons of creative, cultural and
--- scientific works ("Commons") that the public can reliably and without fear
--- of later claims of infringement build upon, modify, incorporate in other
--- works, reuse and redistribute as freely as possible in any form whatsoever
--- and for any purposes, including without limitation commercial purposes.
--- These owners may contribute to the Commons to promote the ideal of a free
--- culture and the further production of creative, cultural and scientific
--- works, or to gain reputation or greater distribution for their Work in
--- part through the use and efforts of others.
--- 
--- For these and/or other purposes and motivations, and without any
--- expectation of additional consideration or compensation, the person
--- associating CC0 with a Work (the "Affirmer"), to the extent that he or she
--- is an owner of Copyright and Related Rights in the Work, voluntarily
--- elects to apply CC0 to the Work and publicly distribute the Work under its
--- terms, with knowledge of his or her Copyright and Related Rights in the
--- Work and the meaning and intended legal effect of CC0 on those rights.
--- 
--- 1. Copyright and Related Rights. A Work made available under CC0 may be
--- protected by copyright and related or neighboring rights ("Copyright and
--- Related Rights"). Copyright and Related Rights include, but are not
--- limited to, the following:
--- 
---   i. the right to reproduce, adapt, distribute, perform, display,
---      communicate, and translate a Work;
---  ii. moral rights retained by the original author(s) and/or performer(s);
--- iii. publicity and privacy rights pertaining to a person's image or
---      likeness depicted in a Work;
---  iv. rights protecting against unfair competition in regards to a Work,
---      subject to the limitations in paragraph 4(a), below;
---   v. rights protecting the extraction, dissemination, use and reuse of data
---      in a Work;
---  vi. database rights (such as those arising under Directive 96/9/EC of the
---      European Parliament and of the Council of 11 March 1996 on the legal
---      protection of databases, and under any national implementation
---      thereof, including any amended or successor version of such
---      directive); and
--- vii. other similar, equivalent or corresponding rights throughout the
---      world based on applicable law or treaty, and any national
---      implementations thereof.
--- 
--- 2. Waiver. To the greatest extent permitted by, but not in contravention
--- of, applicable law, Affirmer hereby overtly, fully, permanently,
--- irrevocably and unconditionally waives, abandons, and surrenders all of
--- Affirmer's Copyright and Related Rights and associated claims and causes
--- of action, whether now known or unknown (including existing as well as
--- future claims and causes of action), in the Work (i) in all territories
--- worldwide, (ii) for the maximum duration provided by applicable law or
--- treaty (including future time extensions), (iii) in any current or future
--- medium and for any number of copies, and (iv) for any purpose whatsoever,
--- including without limitation commercial, advertising or promotional
--- purposes (the "Waiver"). Affirmer makes the Waiver for the benefit of each
--- member of the public at large and to the detriment of Affirmer's heirs and
--- successors, fully intending that such Waiver shall not be subject to
--- revocation, rescission, cancellation, termination, or any other legal or
--- equitable action to disrupt the quiet enjoyment of the Work by the public
--- as contemplated by Affirmer's express Statement of Purpose.
--- 
--- 3. Public License Fallback. Should any part of the Waiver for any reason
--- be judged legally invalid or ineffective under applicable law, then the
--- Waiver shall be preserved to the maximum extent permitted taking into
--- account Affirmer's express Statement of Purpose. In addition, to the
--- extent the Waiver is so judged Affirmer hereby grants to each affected
--- person a royalty-free, non transferable, non sublicensable, non exclusive,
--- irrevocable and unconditional license to exercise Affirmer's Copyright and
--- Related Rights in the Work (i) in all territories worldwide, (ii) for the
--- maximum duration provided by applicable law or treaty (including future
--- time extensions), (iii) in any current or future medium and for any number
--- of copies, and (iv) for any purpose whatsoever, including without
--- limitation commercial, advertising or promotional purposes (the
--- "License"). The License shall be deemed effective as of the date CC0 was
--- applied by Affirmer to the Work. Should any part of the License for any
--- reason be judged legally invalid or ineffective under applicable law, such
--- partial invalidity or ineffectiveness shall not invalidate the remainder
--- of the License, and in such case Affirmer hereby affirms that he or she
--- will not (i) exercise any of his or her remaining Copyright and Related
--- Rights in the Work or (ii) assert any associated claims and causes of
--- action with respect to the Work, in either case contrary to Affirmer's
--- express Statement of Purpose.
--- 
--- 4. Limitations and Disclaimers.
--- 
---  a. No trademark or patent rights held by Affirmer are waived, abandoned,
---     surrendered, licensed or otherwise affected by this document.
---  b. Affirmer offers the Work as-is and makes no representations or
---     warranties of any kind concerning the Work, express, implied,
---     statutory or otherwise, including without limitation warranties of
---     title, merchantability, fitness for a particular purpose, non
---     infringement, or the absence of latent or other defects, accuracy, or
---     the present or absence of errors, whether or not discoverable, all to
---     the greatest extent permissible under applicable law.
---  c. Affirmer disclaims responsibility for clearing rights of other persons
---     that may apply to the Work or any use thereof, including without
---     limitation any person's Copyright and Related Rights in the Work.
---     Further, Affirmer disclaims responsibility for obtaining any necessary
---     consents, permissions or other rights required for any use of the
---     Work.
---  d. Affirmer understands and acknowledges that Creative Commons is not a
---     party to this document and has no duty or obligation with respect to
---     this CC0 or use of the Work.


local utf8 = {}

local bit = require("bit") -- luajit

local band = bit.band
local bor = bit.bor
local rshift = bit.rshift
local lshift = bit.lshift

---@param fun_name string
---@param arg_types { [1]: unknown, [2]: string, [3]: boolean? }[] Array of argument, its expected type and whether it is optional.
---Usage:
---
--- ---@param s string
--- ---@param i number
--- ---@param j? number
--- function foo(s, i, j)
---   assertArgument("foo", {
---     { s, "string" },
---     { i, "number" },
---     { j, "number", true },
---   })
---   -- do something
--- end
local function assertArgument(fun_name, arg_types)
  local msg = "bad argument #%d to '%s' (%s expected, got %s)"
  for i, v in ipairs(arg_types) do
    local arg, expected_type, optional = v[1], v[2], v[3]
    local got_type = type(arg)
    if not (got_type == expected_type or optional and arg == nil) then
      error(msg:format(i, fun_name, expected_type, got_type), 2)
    end
  end
end

---The pattern (a string, not a function) "[\0-\x7F\xC2-\xF4][\x80-\xBF]*",
---which matches exactly one UTF-8 byte sequence, assuming that the subject is a valid UTF-8 string.
utf8.charpattern = "[%z\x01-\x7F\xC2-\xF4][\x80-\xBF]*"

---Receives zero or more integers, converts each one to its corresponding UTF-8 byte sequence
---and returns a string with the concatenation of all these sequences.
---@vararg integer
---@return string
function utf8.char(...)
  local buffer = {}
  for i, v in ipairs({ ... }) do
    if type(v) ~= "number" then
      error(("bad argument #%d to 'char' (number expected, got %s)"):format(i, type(v)))
    elseif v < 0 or v > 0x10FFFF then
      error(("bad argument #%d to 'char' (value out of range)"):format(i))
    elseif v < 0x80 then
      -- single-byte
      buffer[i] = string.char(v)
    elseif v < 0x800 then
      -- two-byte
      local b1 = bor(0xC0, band(rshift(v, 6), 0x1F)) -- 110x-xxxx
      local b2 = bor(0x80, band(v, 0x3F)) -- 10xx-xxxx
      buffer[i] = string.char(b1, b2)
    elseif v < 0x10000 then
      -- three-byte
      local b1 = bor(0xE0, band(rshift(v, 12), 0x0F)) -- 1110-xxxx
      local b2 = bor(0x80, band(rshift(v, 6), 0x3F)) -- 10xx-xxxx
      local b3 = bor(0x80, band(v, 0x3F)) -- 10xx-xxxx
      buffer[i] = string.char(b1, b2, b3)
    else
      -- four-byte
      local b1 = bor(0xF0, band(rshift(v, 18), 0x07)) -- 1111-0xxx
      local b2 = bor(0x80, band(rshift(v, 12), 0x3F)) -- 10xx-xxxx
      local b3 = bor(0x80, band(rshift(v, 6), 0x3F)) -- 10xx-xxxx
      local b4 = bor(0x80, band(v, 0x3F)) -- 10xx-xxxx
      buffer[i] = string.char(b1, b2, b3, b4)
    end
  end
  return table.concat(buffer, "")
end

---@param b number bit
---@return boolean
local function is_tail(b)
  -- 10xx-xxxx (0x80-BF)
  return band(b, 0xC0) == 0x80
end

---Returns the next one character range.
---References: https://datatracker.ietf.org/doc/html/rfc3629#section-4
---@param s string
---@param start_pos integer
---@return integer? start_pos
---@return integer? end_pos
local function next_char(s, start_pos)
  local b1 = s:byte(start_pos)
  if not b1 then
    return
  end
  local b2 = s:byte(start_pos + 1) or -1
  local b3 = s:byte(start_pos + 2) or -1
  local b4 = s:byte(start_pos + 3) or -1

  -- single byte
  if b1 <= 0x7F then
    return start_pos, start_pos
  -- two byte
  elseif 0xC2 <= b1 and b1 <= 0xDF then
    local end_pos = start_pos + 1
    if is_tail(b2) then
      return start_pos, end_pos
    end
  -- three byte
  elseif 0xE0 <= b1 and b1 <= 0xEF then
    local end_pos = start_pos + 2
    if b1 == 0xE0 then
      if (0xA0 <= b2 and b2 <= 0xBF) and is_tail(b3) then
        return start_pos, end_pos
      end
    elseif b1 == 0xED then
      if (0x80 <= b2 and b2 <= 0x9F) and is_tail(b3) then
        return start_pos, end_pos
      end
    else
      if is_tail(b2) and is_tail(b3) then
        return start_pos, end_pos
      end
    end
  -- four byte
  elseif 0xF0 <= b1 and b1 <= 0xF4 then
    local end_pos = start_pos + 3
    if b1 == 0xF0 then
      if (0x90 <= b2 and b2 <= 0xBF) and is_tail(b3) and is_tail(b4) then
        return start_pos, end_pos
      end
    elseif b1 == 0xF4 then
      if (0x80 <= b2 and b2 <= 0x8F) and is_tail(b3) and is_tail(b4) then
        return start_pos, end_pos
      end
    else
      if is_tail(b2) and is_tail(b3) and is_tail(b4) then
        return start_pos, end_pos
      end
    end
  end
end

---Returns values so that the construction
---
---for p, c in utf8.codes(s) do body end
---
---will iterate over all UTF-8 characters in string s, with p being the position (in bytes) and c the code point of each character.
---It raises an error if it meets any invalid byte sequence.
---@param s string
---@return function iterator
function utf8.codes(s)
  assertArgument("codes", {
    { s, "string" },
  })

  local i = 1
  return function()
    if i > #s then
      return
    end

    local start_pos, end_pos = next_char(s, i)
    if start_pos == nil then
      error("invalid UTF-8 code", 2)
    end

    i = end_pos + 1
    return start_pos, s:sub(start_pos, end_pos)
  end
end

---Normalize a index of a string to a positive number.
---@param str string
---@param idx integer
---@return integer
local function normalize_range(str, idx)
  if idx >= 0 then
    return idx
  else
    return #str + idx + 1
  end
end

---Returns the code points (as integers) from all characters in s that start between byte position i and j (both included).
---The default for i is 1 and for j is i.
---It raises an error if it meets any invalid byte sequence.
---@param s string
---@param i? integer start position. default=1
---@param j? integer end position. default=i
---@return integer code point
function utf8.codepoint(s, i, j)
  assertArgument("codepoint", {
    { s, "string" },
    { i, "number", true },
    { j, "number", true },
  })

  i = normalize_range(s, i or 1)
  if i < 1 then
    error("bad argument #2 to 'codepoint' (out of bounds)")
  end
  j = normalize_range(s, j or i)
  if j > #s then
    error("bad argument #3 to 'codepoint' (out of bounds)")
  end

  local ret = {}
  repeat
    local start_pos, end_pos = next_char(s, i)
    if start_pos == nil then
      error("invalid UTF-8 code")
    end

    i = end_pos + 1

    local len = end_pos - start_pos + 1
    if len == 1 then
      -- single-byte
      table.insert(ret, s:byte(start_pos))
    else
      -- multi-byte
      local b1 = s:byte(start_pos)
      b1 = band(lshift(b1, len + 1), 0xFF) -- e.g. 110x-xxxx -> xxxx-x000
      b1 = lshift(b1, len * 5 - 7) -- >> len+1 and << (len-1)*6

      local cp = 0
      for k = start_pos + 1, end_pos do
        local bn = s:byte(k)
        cp = bor(lshift(cp, 6), band(bn, 0x3F))
      end

      cp = bor(b1, cp)
      table.insert(ret, cp)
    end
  until end_pos >= j

  return unpack(ret)
end

---Returns the number of UTF-8 characters in string s that start between positions i and j (both inclusive).
---The default for i is 1 and for j is -1.
---If it finds any invalid byte sequence, returns fail plus the position of the first invalid byte.
---@param s string
---@param i? integer start position. default=1
---@param j? integer end position. default=-1
---@return integer?
---@return integer?
function utf8.len(s, i, j)
  assertArgument("len", {
    { s, "string" },
    { i, "number", true },
    { j, "number", true },
  })

  i = normalize_range(s, i or 1)
  if i < 1 or #s + 1 < i then
    error("bad argument #2 to 'len' (initial position out of bounds)")
  end
  j = normalize_range(s, j or -1)
  if j > #s then
    error("bad argument #3 to 'len' (final position out of bounds)")
  end

  local len = 0

  repeat
    local start_pos, end_pos = next_char(s, i)
    if start_pos == nil then
      return nil, i
    end

    i = end_pos + 1
    len = len + 1
  until end_pos >= j

  return len
end

---Returns the position (in bytes) where the encoding of the n-th character of s (counting from position i) starts.
---A negative n gets characters before position i.
---The default for i is 1 when n is non-negative and #s+1 otherwise, so that utf8.offset(s, -n) gets the offset of the n-th character from the end of the string.
---If the specified character is neither in the subject nor right after its end, the function returns fail.
---
---As a special case, when n is 0 the function returns the start of the encoding of the character that contains the i-th byte of s.
---@param s string
---@param n integer
---@param i? integer start position. if n >= 0, default=1, otherwise default=#s+1
---@return integer?
function utf8.offset(s, n, i)
  assertArgument("offset", {
    { s, "string" },
    { n, "number" },
    { i, "number", true },
  })

  i = i or (n >= 0 and 1 or #s + 1)

  if n >= 0 then
    i = normalize_range(s, i)
    if i <= 0 or #s + 1 <= i then
      error("bad argument #3 to 'offset' (position out of bounds)")
    end
  end

  if n == 0 then
    -- When n is 0, the function returns the start of the encoding of the character that contains the i-th byte of s.
    for j = i, 1, -1 do
      local start_pos = next_char(s, j)
      if start_pos then
        return start_pos
      end
    end
  elseif n > 0 then
    -- Returns the position (in bytes) where the encoding of the n-th character of s (counting from position i) starts.
    if not next_char(s, i) then
      error("initial position is a continuation byte")
    end

    local start_pos = i
    -- `n == 1` expects to return i as is.
    for _ = 1, n - 1 do
      local _, end_pos = next_char(s, start_pos)
      if not end_pos then
        return
      end
      start_pos = end_pos + 1
    end

    return start_pos
  else
    -- A negative n gets characters before position i.
    if i <= #s and not next_char(s, i) then
      error("initial position is a continuation byte")
    end

    -- Array to store the start byte of the nth character.
    local codes = {}
    for p, _ in utf8.codes(s) do
      table.insert(codes, p)
      if i == p then
        -- #codes means how many character start bytes i is.
        -- Therefore, this process makes n the number of the target character.
        -- Note that in this case, `n == -1` refers to the character one before i shows.
        n = n + #codes
        break
      end
    end
    if i == #s + 1 then
      -- When `i == #s+1`, find the -nth (n is negative number) character from end.
      -- Note that in this case, `n == -1` means the starting byte of the end character of the string.
      n = n + #codes + 1
    end

    return codes[n]
  end
end

return utf8
