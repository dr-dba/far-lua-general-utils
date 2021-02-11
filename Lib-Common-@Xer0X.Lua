--[[		(c) Xer0X
	"Православие или Смерть!" group

	Common utils for general use.
]]

-- #####

if not	Xer0X 
then	Xer0X = { }
end

local gsub	= utf8.gsub
local match	= utf8.match
local upper	= utf8.upper
local strlen	= utf8.len
local io_open	= io.open
local uuid	= win.Uuid

local GUID_ZERO	= "00000000-0000-0000-0000-000000000000"

function Xer0X.fnc_str_ins(string, insert, position)
	return string.sub(string, 1, position)..insert..string.sub(string, position + 1)
end

function Xer0X.fnc_str_del(string, from, to)
	return string.sub(string, 1, from - 1)..(j ~= nil and string.sub(string, from + to) or string.sub(string, from + 1))
end

function Xer0X.fnc_str_cnt(str, toCount)
	local i, j = 0, 0
	while j < string.len(str) 
	do
		if string.sub(str, j, j + string.len(toCount) - 1) == toCount 
		then i = i + 1
		end
		j = j + 1
	end
	return i
end

function Xer0X.fnc_str_trim1(str) return str and gsub(str, "^%s*(.-)%s*$", "%1") or str end

function Xer0X.fnc_str_trim_left(str)	return match(str, "^%s*(.*)") end

function Xer0X.fnc_str_trim_right(str)	return match(str, "(.-)%s*$") end

function Xer0X.fnc_norm_menu_value(item_text)
	return item_text and
		string.gsub(
		string.gsub(
		string.gsub(
			Xer0X.fnc_str_trim1(item_text)
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

Xer0X.fnc_norm_guid = function(the_guid)
	if not	the_guid then return end
	local	the_type = type(the_guid)
	if	the_type == "number" or the_type == "userdata" then return end
	if	strlen(the_guid) <= 16
	then 	the_guid = uuid(the_guid)
	end
	if 	the_guid == GUID_ZERO or not the_guid
	then	return
	end
	return upper(the_guid)
end

Xer0X.fnc_norm_script_path = function(scr_path)
	if scr_path == nil then return end
	local ret_val = scr_path
		:gsub(win.GetEnv("FARPROFILE"), "%%FARPROFILE%%")
		:gsub(win.GetEnv("FARHOME"), "%%FARHOME%%")
	return ret_val
end

-- @@@@@
