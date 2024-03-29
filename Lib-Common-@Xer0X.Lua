--[[
		(c) Xer0X
	"Православие или Смерть!" group

	Common utils for the general use.

		DISCLAIMER
	Никто не несет ни за что никакую
		ОТВЕТСТВЕННОСТЬ
]]

-- #####

-- ### OPTIONS BLOCK ###

-- luacheck: ignore 113/Info
local Info = Info or package.loaded.regscript or function(...) return ... end
local nfo = Info({
	_filename or ...,
	name		= "Lib-Common-@Xer0X",
	-- запуск макросов нетрадиционными способами
	description	= "general helping objects and functions",
	id		= "9809B969-68C5-4188-BC1D-77DF21E5CAB7",
	version		= "0.1.7",
	author		= "x-Team",
	url_git		= "https://github.com/dr-dba/far-lua-general-utils",
})
if not nfo then return end
local opts = nfo.options

-- @@@ END OF THE OPTIONS BLOCK @@@

if not Xer0X then _G.Xer0X = { } end

--[[ workaround dedicated to UTF8-related problems
https://forum.farmanager.com/viewtopic.php?p=160846#p160846
@BAX + @HaRT ]]
local lib_uni = unicode.utf8
for ii_key, ii_val in ipairs({ 'len', 'match', 'find', 'gmatch', 'gsub', 'lower', 'upper', 'byte' })
do	local savedName = 'Utf8_'..ii_val
	if not	lib_uni[savedName]
	then	lib_uni[savedName] = lib_uni[ii_val]
		lib_uni[ii_val] = function(str, ...) return (
			lib_uni.utf8valid(str) and
			lib_uni[savedName] or string[ii_val]
				)(str, ...)
		end
	end
end

local far_Guids	= far.Guids
local far_Flags = far.Flags
local far_Colors= far.Colors
local F = far.Flags

local KEY_EVENT		= F.KEY_EVENT
local MOUSE_EVENT	= F.MOUSE_EVENT
local MENU_EVENT	= F.MENU_EVENT
local FOCUS_EVENT	= F.FOCUS_EVENT
local WND_BUF_SIZE_EVT	= F.WINDOW_BUFFER_SIZE_EVENT 
local ACTL_GETFARRECT	= F.ACTL_GETFARRECT
local ACTL_GETCURSORPOS = F.ACTL_GETCURSORPOS
local ACTL_SETCURSORPOS	= F.ACTL_SETCURSORPOS
local ACTL_REDRAWALL	= F.ACTL_REDRAWALL
local EOPT_SHOWTITLEBAR = F.EOPT_SHOWTITLEBAR
local EOPT_SHOWKEYBAR	= F.EOPT_SHOWKEYBAR
local EOPT_SHOWSCROLLBAR= F.EOPT_SHOWSCROLLBAR
local DI_SINGLEBOX	= F.DI_SINGLEBOX
local DI_TEXT		= F.DI_TEXT
local FDLG_NONMODAL	= F.FDLG_NONMODAL
local DN_CLOSE		= F.DN_CLOSE

local far_InputRecordToName 
			= far.InputRecordToName
local mf_postmacro	= mf.postmacro
local editor_GetInfo	= editor.GetInfo
local far_AdvControl	= far.AdvControl
local far_Timer		= far.Timer
local far_Message	= far.Message
local far_Text		= far.Text
local math_max		= math.max
local math_min		= math.min
local bit64_band	= bit64.band

local str_lower = utf8.Utf8_lower	or utf8.lower
local str_upper = utf8.Utf8_upper	or utf8.upper
local str_gmatch= utf8.Utf8_gmatch	or utf8.gmatch
local str_match = utf8.Utf8_match	or utf8.match
local str_find	= utf8.Utf8_find	or utf8.find
local str_gsub	= utf8.Utf8_gsub	or utf8.gsub
local str_rev	= utf8.reverse		or utf8.reverse
local str_len	= utf8.Utf8_len		or utf8.len
local str_sub	= utf8.sub
local str_cfind = utf8.cfind
local str_format= utf8.format
local tbl_concat= table.concat
local tbl_insert= table.insert
local gsub	= utf8.gsub
local match	= utf8.match
local upper	= utf8.upper
local strlen	= utf8.len
local io_open	= io.open
local tostr	= tostring
local win_uuid	= win.Uuid

local string_sub	= string.sub
local string_match	= string.match

-- C.COL_MENUTITLE
local CLR_MENU_TEXT	= far_AdvControl(far_Flags.ACTL_GETCOLOR, far_Colors.COL_MENUHIGHLIGHT)
local GUID_ZERO	= "00000000-0000-0000-0000-000000000000"

local	tbl_far_guid_names = { }
for k, v in pairs(far_Guids)
do	tbl_far_guid_names[v] = k
end
Xer0X.tbl_far_guid_names = tbl_far_guid_names

function Xer0X.fnc_str_escape_magic(str)	return(str_gsub(str, '[%^%$%(%)%%%.%[%]%*%+%-%?]', '%%%1')) end

function Xer0X.fnc_str_replace(str, orig, subs) return str_gsub(str, Xer0X.fnc_str_escape_magic(orig), subs)end

function Xer0X.fnc_str_ins(string, insert, position)
	return str_sub(string, 1, position)..insert..str_sub(string, position + 1)
end

function Xer0X.fnc_str_del(str, from, to)
	return str_sub(str, 1, from - 1)..(to and str_sub(str, from + to) or str_sub(str, from + 1))
end

function Xer0X.fnc_str_cnt(str, str_to_count)
	local ii, jj = 0, 0
	while jj < str_len(str)
	do	if str_to_count == str_sub(str, jj, jj + str_len(str_to_count) - 1)
		then ii = ii + 1
		end
		jj = jj + 1
	end
	return ii
end

function Xer0X.fnc_str_trim1(str) return str and gsub(str, "^%s*(.-)%s*$", "%1") or str end

function Xer0X.fnc_str_trim_left(str)	return match(str, "^%s*(.*)") end

function Xer0X.fnc_str_trim_right(str)	return match(str, "(.-)%s*$") end

function Xer0X.fnc_norm_menu_value(item_text)
	return item_text and
		str_gsub(
		str_gsub(
		str_gsub(
			Xer0X.fnc_str_trim1(item_text)
			, "&"	,	"<&AND>")
			, "<&AND><&AND>", "&"	)
			, "<&AND>"	, ""	)
end


local function fnc_cfind_safe(str, expr, line_pos, is_plain)
	local	res, pos, fin, fnd = pcall(str_cfind, str, expr, line_pos, is_plain)
	return	res,
		not res and pos or nil,
		res and pos or nil,
		res and fin or nil,
		res and fnd or nil
end

Xer0X.fnc_cfind_safe = fnc_cfind_safe

function Xer0X.fnc_file_exists(file_path)
	local	hnd = io_open(file_path, "r")
	if	hnd
	then	hnd:close()
		return true
	else	return false
	end
end

local function fnc_tbl_copy(tbl_src, tbl_new, no_dest_overwrite)
	if not	tbl_new
	then	tbl_new = { }
	end
	local	ii, val
	repeat	ii, val = next(tbl_src, ii)
		if ii and (not no_dest_overwrite or tbl_new[ii] == nil) 
		then tbl_new[ii] = type(val) == "table" and fnc_tbl_copy(val) or val 
		end
	until not ii
	return tbl_new
end

local function fnc_tbl_copy_to(tbl_from, key_from, tbl_dest, key_dest, fnc_how_tbl, fnc_how_val)
	if type(key_from) == "table"
	and type(tbl_dest)~= "table"
	-- shift right
	then	fnc_how_val =	fnc_how_tbl
		fnc_how_tbl =	key_dest
		key_dest =	tbl_dest
		tbl_dest =	key_from
		key_from =	nil
	end
	if type(key_dest) == "function"
	-- shift right
	then	fnc_how_val =	fnc_how_tbl
		fnc_how_tbl =	key_dest
		key_dest =	nil
	end
	if not	tbl_dest
	then	tbl_dest = { }
	end
	if	key_dest == nil
	and	key_from ~= nil
	then	key_dest = key_from
	end
	local	tbl_from_loc
	local	tbl_dest_loc
	if	key_from
	then	tbl_from_loc = tbl_from[key_from]
	else	tbl_from_loc = tbl_from
		tbl_from = nil
	end
	if	key_dest
	then	if not	tbl_dest[key_dest]
		then	tbl_dest[key_dest] = { }
		end
		tbl_dest_loc = tbl_dest[key_dest]
	else	tbl_dest_loc = tbl_dest
		tbl_dest = nil
	end
	for ii_key, ii_val in pairs(tbl_from_loc)
	do	if type(ii_val) == "table"
		then	if not	fnc_how_tbl
			or not	fnc_how_tbl(tbl_from, tbl_from_loc, tbl_dest, tbl_dest_loc, ii_key, ii_val)
			then
				if type(ii_key) == "number"
				and	ii_key <= #tbl_from_loc
				then	tbl_dest_loc[#tbl_dest_loc + 1]
						= fnc_tbl_copy_to(tbl_from_loc, ii_key, tbl_dest_loc, #tbl_dest_loc + 1,fnc_how_tbl, fnc_how_val)
				else	tbl_dest_loc[ii_key]
						= fnc_tbl_copy_to(tbl_from_loc, ii_key, tbl_dest_loc, ii_key,		fnc_how_tbl, fnc_how_val)
				end
			end
		else	if not	fnc_how_val
			or not	fnc_how_val(tbl_from, tbl_from_loc, tbl_dest, tbl_dest_loc, ii_key, ii_val)
			then	if type(ii_key) == "number"
				and	ii_key <= #tbl_from_loc
				then	tbl_dest_loc[#tbl_dest_loc + 1] = ii_val
				else	tbl_dest_loc[ii_key]		= ii_val
				end
			end
		end
	end
	return tbl_dest_loc
end -- fnc_tbl_copy_to

Xer0X.fnc_tbl_copy	= fnc_tbl_copy
Xer0X.fnc_tbl_copy_to	= fnc_tbl_copy_to

function Xer0X.fnc_tbl_count(t)
	if type(t) ~= "table"
	then return -1
	end
	local n = 0
	for k, v in next, t
	do n = n + 1
	end
	return n
end

Xer0X.fnc_norm_guid = function(the_guid)
	if not	the_guid then return end
	local	the_type = type(the_guid)
	if	the_type == "number"
	or	the_type == "userdata"
	then	return
	end
	if	strlen(the_guid) <= 16
	then 	the_guid = win_uuid(the_guid)
	end
	if 	the_guid == GUID_ZERO or not the_guid
	then	return
	end
	return upper(the_guid)
end -- fnc_norm_guid(..)

Xer0X.fnc_norm_script_path = function(scr_path)
	if scr_path == nil then return end
	local ret_val = scr_path
		:gsub(win.GetEnv("APPDATA").."\\",	"%%APPDATA%%\\")
		:gsub(win.GetEnv("LOCALAPPDATA").."\\",	"%%LOCALAPPDATA%%\\")
		:gsub(win.GetEnv("USERNAME").."\\",	"%%USERNAME%%\\")
		:gsub(win.GetEnv("FARPROFILE").."\\",	"%%FARPROFILE%%\\")
		:gsub(win.GetEnv("FARHOME").."\\",	"%%FARHOME%%\\")
	return ret_val
end

function Xer0X.fnc_safe_require(the_module, quiet)
	local	req_res_1, req_res_2, req_res_3, req_res_4, req_res_5
	local	ok, err_msg = pcall(function()
		req_res_1, req_res_2, req_res_3, req_res_4, req_res_5
			= require(the_module)
		end)
	if not	ok and not quiet
	then	far.Message(err_msg, "require "..the_module, nil, "w")
	end
	return ok, err_msg, req_res_1, req_res_2, req_res_3, req_res_4, req_res_5
end


function Xer0X.fnc_file_text_load(sz_file_path)
	local f = io.open(sz_file_path, "r")
	local text = f:read("*all")
	f:close()
	return text
end

function Xer0X.fnc_file_text_save(sz_file_path, text)
	local f = io.open(sz_file_path, "w")
	f:write(text)
	f:close()
end

function Xer0X.fnc_path_dissect(sz_file_path, no_end_slash)
	local	path_part = str_match(str_match(sz_file_path, "^(.+[\\/])"), "(.+[^\\/])")
	local	path_fold = path_part and path_part or sz_file_path
	if	string_sub(sz_file_path, 1, 4) == "\\\\?\\"
	then	-- Plugin?
		path_fold = string_sub(path_fold, 5)
	end
	if	string_sub(path_fold, 1, 4) == "UNC\\"
	then	-- Network?
		path_fold = "\\"..string_sub(path_fold, 4)
	end
	local	unc_host = string_match(path_fold, "^\\\\([^\\]+)")
	local	path_root = unc_host
			and	string_match(path_fold, "^\\\\.-\\[^\\]+[^\\]") 
			or	string_match(path_fold, "^[^\\]:") 
	return	path_root == path_fold, path_root, path_fold
end -- fnc_path_dissect

local function fnc_macro_key_run(key_inp)
	local	is_macro
	local	ret_code = eval(key_inp, 2)
	if	ret_code == -2
	then	ret_code = Keys(key_inp)
		is_macro = false
	else	is_macro = true
	end
	return	ret_code, is_macro
end

Xer0X.fnc_macro_key_run = fnc_macro_key_run


Xer0X.obj_screen_status_line = {
	stop = function(self)
		self.timer:Close()
	end,
	start = function(self)
		self:set(self.text_show, self.color_txt, self.time_show)
	end,
	is_run = function(self)
		return self.timer and not self.timer.Closed
	end,
	set = function(self, text_str, txt_color, ms_show_time, in_timer)
		if not	in_timer
		then
			local do_redraw
			if	self.text_show ~= text_str
			then	self.text_show  = text_str; do_redraw = true
			end
			if	self.color_txt ~= txt_color
			then	self.color_txt  = txt_color;do_redraw = true
			end
			if	ms_show_time
			then	self.time_show = ms_show_time
				self.timeStart = Far.UpTime
				if not	self.timer
				or	self.timer.Closed
				then	self.timer = far_Timer(1000, function(sender)
						if	self.time_show < Far.UpTime - self.timeStart
						or not	self.text_show
						then	self.timer:Close()
							far_AdvControl("ACTL_REDRAWALL")
						else	self:set(self.text_show, self.color_txt, nil, true)
						end
					end)
				end
			end
			if do_redraw 
			then	far_AdvControl("ACTL_REDRAWALL") 
			end
		end
		if text_str
		then far_Text(
			1, 0, txt_color or CLR_MENU_TEXT,
			text_str == "" and "" or " "..text_str.." "
				)
		end
		far_Text()
	end -- fnc_status_set
} 

local tmr_trans_msg
local TRANS_MSG_CLOSE_TIME_MS = 3000
local TRANS_MSG_CHECK_TIME_MS = 100

function Xer0X.fnc_trans_msg(msg_status, msg_title, msg_flags, msg_buttons, close_on_key_press)
	if	tmr_trans_msg
	and not	tmr_trans_msg.Closed
	then	tmr_trans_msg:Close()
	end
	if	msg_status == "OFF"
	and not msg_title
	and not msg_flags
	and not msg_buttons
	then	return
	end
	local	msg_res
	local	is_transient = msg_buttons == ""
	if	is_transient
	then
		local function fnc_msg_tmp(caller, t_start, close_on_key_press)
			local is_timeout
			::show_msg::
			far.Message(msg_status, msg_title, msg_buttons, msg_flags)
			::check_timeout::
			is_timeout = is_timeout or t_start and (Far.UpTime - t_start > TRANS_MSG_CLOSE_TIME_MS)
			if	caller
			and not	caller.Closed
			then	if	is_timeout
				then	caller:Close()
					far_AdvControl("ACTL_REDRAWALL")
				else	if	close_on_key_press
					then	caller.Enabled = false
						local	sz_vk = mf.waitkey(TRANS_MSG_CHECK_TIME_MS - 1)
						if	sz_vk == ""
						then	goto show_msg
						else	local ok_post, ret_msg = mf.postmacro(fnc_macro_key_run, sz_vk)
							is_timeout = true
							goto check_timeout
						end
					end
				end
			end
		end

		t1 = Far.UpTime
		fnc_msg_tmp(tmr_trans_msg)
		tmr_trans_msg = far_Timer(TRANS_MSG_CHECK_TIME_MS, fnc_msg_tmp, Far.UpTime, close_on_key_press)
	else
		msg_res = far_Message(msg_status, msg_title, msg_buttons, msg_flags)
	end
	return	msg_res
end

function Xer0X.fnc_case_title(str)
	local function fnc_title_int(first, rest) return first:upper()..rest:lower() end
	return string.gsub(str, "(%a)([%w']*)", fnc_title_int)
end

function Xer0X.fnc_case_toggle(str)
	local function fnc_toggle_int(first, rest) return first:lower()..rest:upper() end
	return string.gsub(str, "(%a)([%w']*)", fnc_toggle_int)
end

do -- key prettifying code block

local tbl_keys_prty = { }
local tbl_keys_ugly = { }

local function fnc_key_title(str_key)

	local function fnc_key_title_loc(first, rest)
		return first..rest:sub(1, 1):upper()..rest:sub(2)
	end

	return fnc_key_title_loc("", str_key)
		:gsub("(Ctrl)([%w']*)"	, fnc_key_title_loc)
		:gsub("(Alt)([%w']*)"	, fnc_key_title_loc)
		:gsub("(Shift)([%w']*)"	, fnc_key_title_loc)
		:gsub("(-)([%w']*)"	, fnc_key_title_loc)
end

function Xer0X.fnc_key_prettify(str_key)
	if	tbl_keys_prty[str_key]
	then -- already pretty
		return	str_key
	else	local	ret_val = tbl_keys_ugly[str_key]
		if not	ret_val
		then	ret_val = fnc_key_title(str_key
				:gsub("minus",	"Minus"		)
				:gsub("shift",	"Shift"		)
				:gsub("rctrl",	"RCtrl"		)
				:gsub("lctrl",	"LCtrl"		)
				:gsub("ctrl",	"Ctrl"		)
				:gsub("ralt",	"RAlt"		)
				:gsub("lalt",	"LAlt"		)
				:gsub("alt",	"Alt"		)
				:gsub("CtrLAlt","CtrlAlt"	)
				:gsub("pgdn",	"PgDn"		)
				:gsub("pgup",	"PgUp"		)
				:gsub(":hold",	":Hold"		)
				:gsub(":double",":Double"	)
					)
			tbl_keys_ugly[str_key] = ret_val
			tbl_keys_prty[ret_val] = true
		end
		return ret_val
	end
end -- fnc_key_prettify

end -- end of key prettifying code block

function Xer0X.fnc_cons_edit_curs_geomtr(editor_id, edit_info, curs_pstn, cons_rect)
	edit_info = edit_info or editor_GetInfo(editor_id)
	if not edit_info then return end
	curs_pstn = curs_pstn or far_AdvControl(ACTL_GETCURSORPOS)
	cons_rect = cons_rect or far_AdvControl(ACTL_GETFARRECT)
	local tbl_rtvl = {
		cons_rect	 = cons_rect,
		curs_pstn	 = curs_pstn,
		edit_info	 = edit_info,
		DPosX	= math_max(curs_pstn.X - (edit_info.CurTabPos	+ 0 - edit_info.LeftPos		), 0),
		DPosY	= math_max(curs_pstn.Y - (edit_info.CurLine	+ 0 - edit_info.TopScreenLine	), 0),
		DSizeX	= math_max(cons_rect.Right	- cons_rect.Left+ 1 - edit_info.WindowSizeX,	0),
		DSizeY	= math_max(cons_rect.Bottom	- cons_rect.Top	+ 1 - edit_info.WindowSizeY,	0),
	}
	tbl_rtvl.EPosX = math_max(tbl_rtvl.DSizeX - tbl_rtvl.DPosX, 0)
	tbl_rtvl.EPosY = math_max(tbl_rtvl.DSizeY - tbl_rtvl.DPosY, 0)
	tbl_rtvl.EPosX1= tbl_rtvl.DPosX
	tbl_rtvl.EPosY1= tbl_rtvl.DPosY					- (bit64_band(edit_info.Options, EOPT_SHOWTITLEBAR)== EOPT_SHOWTITLEBAR	and 1 or 0)
	tbl_rtvl.EPosX2= tbl_rtvl.EPosX1 + edit_info.WindowSizeX - 1	+ (bit64_band(edit_info.Options, EOPT_SHOWSCROLLBAR)==EOPT_SHOWSCROLLBAR and 1 or 0)
	tbl_rtvl.EPosY2= tbl_rtvl.EPosY1 + edit_info.WindowSizeY - 1	+ (bit64_band(edit_info.Options, EOPT_SHOWKEYBAR ) == EOPT_SHOWKEYBAR	and 1 or 0)
	return tbl_rtvl
end

function Xer0X.fnc_guid_name(guid)
	if	guid
	and	guid:len() == 16
	then	guid = win_uuid(guid)
	end
	guid = guid and guid:upper() or ""
	for n, v in pairs(far.Guids)
	do	if v == guid
		then return n
		end
	end
	return nil
end -- fnc_guid_name

function Xer0X.fnc_flag_name(flag, prefix)
	prefix = prefix and "^"..prefix or ".+"
	for n, v in pairs(far_Flags)
	do	if flag == v
		and n:find(prefix)
		then return n
		end
	end
	return nil
end -- fnc_flag_name

function Xer0X.fnc_flag_names(flags_bin, pfx_expr, strict)
	local str_flags = "NONE"
	local tbl_flags = { }
	for flag_str, flag_bin in pairs(far_Flags)
	do	if (	pfx_expr == nil
		or	pfx_expr == ""
		or	str_match(flag_str, pfx_expr)
				)
		and (	strict
		and	flags_bin == flag_bin
		or not	strict
		and	band(flags_bin, flag_bin) == flag_bin
				)
		then
			str_flags = str_flags.." "..flag_str.."/"..flag_bin
			tbl_flags[flag_str] = true
			if strict then break end
		end
	end
	str_flags = str_gsub(str_flags, "NONE ", "")
	if	str_flags == "NONE"
	then	str_flags =  "NONE/"..tostring(flags_bin)
	end
	return str_flags, tbl_flags
end

function Xer0X.fnc_str_split(str_inp, sep, uniq_only) 
	if	sep == nil
	then	sep = "%s"
	end
	local tbl_res = { }
	local tbl_unq = uniq_only and { }
	local ii = 1
	for ii_str in str_gmatch(str_inp, "([^"..sep.."]+)")
	do	if	uniq_only
		then	if	tbl_unq[ii_str]
			then	tbl_unq[ii_str] = 1 + tbl_unq[ii_str]
			else	tbl_unq[ii_str] = 1
				tbl_res[ii] = ii_str
				ii = ii + 1
			end
		else	tbl_res[ii] = ii_str
			ii = ii + 1
		end
	end
	return tbl_res, tbl_unq
end

function Xer0X.fnc_num_to_str(n)
	if	n == nil
	then	return "+<NiL>"
	elseif	n == 0
	and	1 / n < 0
	then	return "-0"
	elseif	1 / n == 0
	then	return n < 0 and "-inf" or "+inf"
	elseif	n ~= n
	then	return "nan"
	else	return string.format("%+1.5g", n) 
	end
end

function Xer0X.fnc_pcall_expect_error(f, msg)
	local	ok, err = pcall(f)
	if	ok
	then	error("error check unexpectedly succeeded", 2) 
	end
	if	msg 
	then	if type(err) ~= "string" 
		then error("error check failed with "..tostring(err), 2)
		end
		local line, err2 = string.match(err, ":(%d*): (.*)")
		if err2 ~= msg 
		then	if err2:gsub(" got no value", " got nil") == msg 
			then return
			end
			error("error check failed with "..err, 2)
		end
	end
end

function Xer0X.fnc_file_desc_get(file)
	local sz_descr
	local p = file:match(".*\\") or ""
	local n = file:sub(p:len() + 1)
	for df in Far.Cfg_Get("Descriptions", "ListNames"):lower():gmatch("[^,]+")
	do	if win.GetFileAttr(p..df) 
		then	local F = far.Flags
			editor.Editor(p..df, nil, nil, nil, nil, nil, F.EF_NONMODAL + F.EF_IMMEDIATERETURN + F.EF_DISABLEHISTORY + F.EF_DISABLESAVEPOS)
			local cp = editor.GetInfo().CodePage
			editor.Quit()
			far.AdvControl("ACTL_COMMIT")
			for s in io.lines(p..df) 
			do	s = win.Utf16ToUtf8(win.MultiByteToWideChar(s, cp))
				if regex.find(s, n, 1, "i") 
				then	sz_descr = regex.gsub(s, '/^.*?'..n..'"?[\t ]+/i', "")
					break
				end
			end
		end
		if sz_descr then break end
	end
	return sz_descr
end

function Xer0X.fnc_ffi_bin_to_hex(bytes, len)
	return string.gsub(
		ffi.string(bytes, len), 
		'(.)', 
		function(c) return string.format('%02x', string.byte(c)) end
	)
end

if not	_G.ffi
then	_G.ffi = require("ffi")
end
local ffi = _G.ffi

local function fnc_ffi_cdef_safe(def_txt, silent)
	local	res, err = pcall(ffi.cdef, def_txt)
	if not	res
	and not silent
	then	local dbginf = debug.getinfo(2, "nSl")
		local msg = string.format("%s:%d\n---\n%s\n---\n%s", dbginf.short_src, dbginf.currentline, err, def_txt)
		far.Message(msg, "FFi cDef load error", nil, "wl")
	end
	return	res, err
end

Xer0X.fnc_ffi_cdef_safe = fnc_ffi_cdef_safe

local tbl_hld_keys = { }
Xer0X.tbl_hld_keys = tbl_hld_keys
Xer0X.cnt_hld_all_keys = 0


return Xer0X

-- @@@@@
