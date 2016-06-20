local ver = "0.03"
function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        DownloadFileAsync("https://raw.githubusercontent.com/gamsteron/GameOnSteroids/master/AutoLVL.lua", SCRIPT_PATH .. "AutoLVL.lua", function() PrintChat("Update Complete, please 2x F6!") return end)
    else
        PrintChat(string.format("<font color='#b756c5'>GamSterOn AutoLVL </font>").."updated ! Version: "..ver)
    end
end
GetWebResultAsync("https://raw.githubusercontent.com/gamsteron/GameOnSteroids/master/AutoLVL.version", AutoUpdate)

GSOALU = MenuConfig("gsoalu", "GamSterOn Auto LVL UP")
GSOALU:DropDown("SWITCH", "Level Up Mode ->", 2, {"CUSTOM", "RQWE", "RQEW", "RWQE", "RWEQ", "REQW", "REWQ"})
GSOALU:Boolean("HUMANIZER", "Humanizer", false)
GSOALU:Slider("START", "Start Level", 2,1,2,1)
GSOALU:Menu("CUSTOM", "Custom selection")
GSOALU.CUSTOM:DropDown("FIRST", "1", 1, {"Q", "W", "E", "R"})
GSOALU.CUSTOM:DropDown("SECOND", "2", 1, {"Q", "W", "E", "R"})
GSOALU.CUSTOM:DropDown("THIRD", "3", 1, {"Q", "W", "E", "R"})
GSOALU.CUSTOM:DropDown("FOURTH", "4", 1, {"Q", "W", "E", "R"})
GSOALU.CUSTOM:DropDown("FIFTH", "5", 1, {"Q", "W", "E", "R"})
GSOALU.CUSTOM:DropDown("SIXTH", "6", 1, {"Q", "W", "E", "R"})
GSOALU.CUSTOM:DropDown("SEVENTH", "7", 1, {"Q", "W", "E", "R"})
GSOALU.CUSTOM:DropDown("EIGHTH", "8", 1, {"Q", "W", "E", "R"})
GSOALU.CUSTOM:DropDown("NINTH", "9", 1, {"Q", "W", "E", "R"})
GSOALU.CUSTOM:DropDown("TENTH", "10", 1, {"Q", "W", "E", "R"})
GSOALU.CUSTOM:DropDown("ELEVENTH", "11", 1, {"Q", "W", "E", "R"})
GSOALU.CUSTOM:DropDown("TWELFTH", "12", 1, {"Q", "W", "E", "R"})
GSOALU.CUSTOM:DropDown("THIRTEENTH", "13", 1, {"Q", "W", "E", "R"})
GSOALU.CUSTOM:DropDown("FOURTEENTH", "14", 1, {"Q", "W", "E", "R"})
GSOALU.CUSTOM:DropDown("FIFTEENTH", "15", 1, {"Q", "W", "E", "R"})
GSOALU.CUSTOM:DropDown("SIXTEENTH", "16", 1, {"Q", "W", "E", "R"})
GSOALU.CUSTOM:DropDown("SEVENTEENTH", "17", 1, {"Q", "W", "E", "R"})
GSOALU.CUSTOM:DropDown("EIGHTEENTH", "18", 1, {"Q", "W", "E", "R"})

local GSOALUTIMER = 0
local GSOALURQWE = {_Q,_W,_E,_Q,_Q,_R,_Q,_W,_Q,_W,_R,_W,_W,_E,_E,_R,_E,_E}
local GSOALURQEW = {_Q,_E,_W,_Q,_Q,_R,_Q,_E,_Q,_E,_R,_E,_E,_W,_W,_R,_W,_W}
local GSOALURWQE = {_W,_Q,_E,_W,_W,_R,_W,_Q,_W,_Q,_R,_Q,_Q,_E,_E,_R,_E,_E}
local GSOALURWEQ = {_W,_E,_Q,_W,_W,_R,_W,_E,_W,_E,_R,_E,_E,_Q,_Q,_R,_Q,_Q}
local GSOALUREQW = {_E,_Q,_W,_E,_E,_R,_E,_Q,_E,_Q,_R,_Q,_Q,_W,_W,_R,_W,_W}
local GSOALUREWQ = {_E,_W,_Q,_E,_E,_R,_E,_W,_E,_W,_R,_W,_W,_Q,_Q,_R,_Q,_Q}

OnTick(function (myHero)
        if GetTickCount() > GSOALUTIMER + 1000 then
                local CASE = GSOALU.SWITCH:Value()
                local START = GSOALU.START:Value()
                local LEVEL = GetLevel(myHero)
                local PLUS = GetCastLevel(myHero, _Q) + GetCastLevel(myHero, _W) + GetCastLevel(myHero, _E) + GetCastLevel(myHero, _R)
                if LEVEL > PLUS and LEVEL >= START then
                        if CASE == 1 then
                                if LEVEL == 1 then
                                        GSOALULevelCustomSpell(GSOALU.CUSTOM.FIRST:Value())
                                elseif LEVEL == 2 then
                                        GSOALULevelCustomSpell(GSOALU.CUSTOM.SECOND:Value())
                                elseif LEVEL == 3 then
                                        GSOALULevelCustomSpell(GSOALU.CUSTOM.THIRD:Value())
                                elseif LEVEL == 4 then
                                        GSOALULevelCustomSpell(GSOALU.CUSTOM.FOURTH:Value())
                                elseif LEVEL == 5 then
                                        GSOALULevelCustomSpell(GSOALU.CUSTOM.FIFTH:Value())
                                elseif LEVEL == 6 then
                                        GSOALULevelCustomSpell(GSOALU.CUSTOM.SIXTH:Value())
                                elseif LEVEL == 7 then
                                        GSOALULevelCustomSpell(GSOALU.CUSTOM.SEVENTH:Value())
                                elseif LEVEL == 8 then
                                        GSOALULevelCustomSpell(GSOALU.CUSTOM.EIGHTH:Value())
                                elseif LEVEL == 9 then
                                        GSOALULevelCustomSpell(GSOALU.CUSTOM.NINTH:Value())
                                elseif LEVEL == 10 then
                                        GSOALULevelCustomSpell(GSOALU.CUSTOM.TENTH:Value())
                                elseif LEVEL == 11 then
                                        GSOALULevelCustomSpell(GSOALU.CUSTOM.ELEVENTH:Value())
                                elseif LEVEL == 12 then
                                        GSOALULevelCustomSpell(GSOALU.CUSTOM.TWELFTH:Value())
                                elseif LEVEL == 13 then
                                        GSOALULevelCustomSpell(GSOALU.CUSTOM.THIRTEENTH:Value())
                                elseif LEVEL == 14 then
                                        GSOALULevelCustomSpell(GSOALU.CUSTOM.FOURTEENTH:Value())
                                elseif LEVEL == 15 then
                                        GSOALULevelCustomSpell(GSOALU.CUSTOM.FIFTEENTH:Value())
                                elseif LEVEL == 16 then
                                        GSOALULevelCustomSpell(GSOALU.CUSTOM.SIXTEENTH:Value())
                                elseif LEVEL == 17 then
                                        GSOALULevelCustomSpell(GSOALU.CUSTOM.SEVENTEENTH:Value())
                                else
                                        GSOALULevelCustomSpell(GSOALU.CUSTOM.EIGHTEENTH:Value())
                                end
                        elseif CASE == 2 then
                                GSOALULevelUp(LEVEL, 1, _W, GSOALURQWE[LEVEL])
                        elseif CASE == 3 then
                                GSOALULevelUp(LEVEL, 1, _E, GSOALURQEW[LEVEL])
                        elseif CASE == 4 then
                                GSOALULevelUp(LEVEL, 2, _Q, GSOALURWQE[LEVEL])
                        elseif CASE == 5 then
                                GSOALULevelUp(LEVEL, 2, _E, GSOALURWEQ[LEVEL])
                        elseif CASE == 6 then
                                GSOALULevelUp(LEVEL, 3, _Q, GSOALUREQW[LEVEL])
                        else
                                GSOALULevelUp(LEVEL, 3, _W, GSOALUREWQ[LEVEL])
                        end
                end
                GSOALUTIMER = GetTickCount()
        end
end)

function GSOALULevelUp(level, dolvlfirst, dolvlsecond, dolvlfromtable)
        local num = GenerateRandomFloat(0.5, 1)
        if level == 2 then
                if dolvlfirst == 1 then 
                        local q = GetCastLevel(myHero, _Q)
                        if q == 1 then
                                if GSOALU.HUMANIZER:Value() then
                                        DelayAction(function() LevelSpell(dolvlsecond) end,num)
                                else
                                        LevelSpell(dolvlsecond)
                                end
                        else
                                if GSOALU.HUMANIZER:Value() then
                                        DelayAction(function() LevelSpell(_Q) end,num)
                                else
                                        LevelSpell(_Q)
                                end
                        end
                elseif dolvlfirst == 2 then
                        local w = GetCastLevel(myHero, _W)
                        if w == 1 then
                                if GSOALU.HUMANIZER:Value() then
                                        DelayAction(function() LevelSpell(dolvlsecond) end,num)
                                else
                                        LevelSpell(dolvlsecond)
                                end
                        else
                                if GSOALU.HUMANIZER:Value() then
                                        DelayAction(function() LevelSpell(_W) end,num)
                                else
                                        LevelSpell(_W)
                                end
                        end
                else
                        local e = GetCastLevel(myHero, _E)
                        if e == 1 then
                                if GSOALU.HUMANIZER:Value() then
                                        DelayAction(function() LevelSpell(dolvlsecond) end,num)
                                else
                                        LevelSpell(dolvlsecond)
                                end
                        else
                                if GSOALU.HUMANIZER:Value() then
                                        DelayAction(function() LevelSpell(_E) end,num)
                                else
                                        LevelSpell(_E)
                                end
                        end
                end
        elseif level == 3 then
                if dolvlfirst == 1 then
                        local w = GetCastLevel(myHero, _W)
                        if w == 1 then
                                if GSOALU.HUMANIZER:Value() then
                                        DelayAction(function() LevelSpell(_E) end,num)
                                else
                                        LevelSpell(_E)
                                end
                        else
                                if GSOALU.HUMANIZER:Value() then
                                        DelayAction(function() LevelSpell(_W) end,num)
                                else
                                        LevelSpell(_W)
                                end
                        end
                elseif dolvlfirst == 2 then
                        local q = GetCastLevel(myHero, _Q)
                        if q == 1 then
                                if GSOALU.HUMANIZER:Value() then
                                        DelayAction(function() LevelSpell(_E) end,num)
                                else
                                        LevelSpell(_E)
                                end
                        else
                                if GSOALU.HUMANIZER:Value() then
                                        DelayAction(function() LevelSpell(_Q) end,num)
                                else
                                        LevelSpell(_Q)
                                end
                        end
                else
                        local q = GetCastLevel(myHero, _Q)
                        if q == 1 then
                                if GSOALU.HUMANIZER:Value() then
                                        DelayAction(function() LevelSpell(_W) end,num)
                                else
                                        LevelSpell(_W)
                                end
                        else
                                if GSOALU.HUMANIZER:Value() then
                                        DelayAction(function() LevelSpell(_Q) end,num)
                                else
                                        LevelSpell(_Q)
                                end
                        end
                end
        else
                if GSOALU.HUMANIZER:Value() then
                        DelayAction(function() LevelSpell(dolvlfromtable) end,num)
                else
                        LevelSpell(dolvlfromtable)
                end
        end
end

function GSOALULevelCustomSpell(spell)
        local num = GenerateRandomFloat(0.5, 1)
        if spell == 1 then
                if GSOALU.HUMANIZER:Value() then
                        DelayAction(function() LevelSpell(_Q) end,num)
                else
                        LevelSpell(_Q)
                end
        elseif spell == 2 then
                if GSOALU.HUMANIZER:Value() then
                        DelayAction(function() LevelSpell(_W) end,num)
                else
                        LevelSpell(_W)
                end
        elseif spell == 3 then
                if GSOALU.HUMANIZER:Value() then
                        DelayAction(function() LevelSpell(_E) end,num)
                else
                        LevelSpell(_E)
                end
        else
                if GSOALU.HUMANIZER:Value() then
                        DelayAction(function() LevelSpell(_R) end,num)
                else
                        LevelSpell(_R)
                end
        end
end

function GenerateRandomFloat(lower, greater)
    return lower + math.random()  * (greater - lower)
end
