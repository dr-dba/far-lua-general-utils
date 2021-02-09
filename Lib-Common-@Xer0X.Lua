--[[!		(c) Xer0X
	"Православие или Смерть!" group

	Common utils for general use.
]]

-- #####

if not	Xer0X 
then	Xer0X = { }
end

local gsub	= utf8.gsub
local match	= utf8.match
local io_open	= io.open

function Xer0X.fnc_trim1(str) return str and gsub(str, "^%s*(.-)%s*$", "%1") or str end

function Xer0X.fnc_str_trim_left(str)	return match(str, "^%s*(.*)") end

function Xer0X.fnc_str_trim_right(str)	return match(str, "(.-)%s*$") end

function Xer0X.fnc_norm_menu_value(item_text)
	return item_text and
		string.gsub(
		string.gsub(
		string.gsub(
			Xer0X.fnc_trim1(item_text)
			, "&", "<&AND>")
			, "<&AND><&AND>", "&")
			, "<&AND>", "")
end

function Xer0X.fnc_file_exists(file_path) 
	local	hnd = io_open(file_path, "r")
	if	hnd
	then	hnd:close()
		return true
	else	return false
	end
end

local function fnc_tbl_copy(tbl_src)	
	local tbl_new = { }
	local ii, val
	repeat	ii, val = next(tbl_src, ii)
		if ii then tbl_new[ii] = type(val) == "table" and fnc_tbl_copy(val) or val end
	until not ii
	return tbl_new
end

Xer0X.fnc_tbl_copy = fnc_tbl_copy

-- @@@@@
