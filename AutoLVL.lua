local ver = "0.01"
function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        DownloadFileAsync("https://raw.githubusercontent.com/gamsteron/GameOnSteroids/master/AutoLVL.lua", SCRIPT_PATH .. "AutoLVL.lua", function() PrintChat("Update Complete, please 2x F6!") return end)
    else
        PrintChat(string.format("<font color='#b756c5'>GamSterOn AutoLVL </font>").."updated ! Version: "..ver)
    end
end
GetWebResultAsync("https://raw.githubusercontent.com/gamsteron/GameOnSteroids/master/AutoLVL.version", AutoUpdate)

Config = MenuConfig("GSOALU", "GamSterOn Auto LVL UP")
Config:DropDown("SWITCH", "Level Up Mode ->", 2, {"CUSTOM", "RQWE", "RQEW", "RWQE", "RWEQ", "REQW", "REWQ"})
Config:Slider("START", "Start Level", 2,1,2,1)
Config:Menu("CUSTOM", "Custom selection")
Config.CUSTOM:DropDown("FIRST", "1", 1, {"Q", "W", "E", "R"})
Config.CUSTOM:DropDown("SECOND", "2", 1, {"Q", "W", "E", "R"})
Config.CUSTOM:DropDown("THIRD", "3", 1, {"Q", "W", "E", "R"})
Config.CUSTOM:DropDown("FOURTH", "4", 1, {"Q", "W", "E", "R"})
Config.CUSTOM:DropDown("FIFTH", "5", 1, {"Q", "W", "E", "R"})
Config.CUSTOM:DropDown("SIXTH", "6", 1, {"Q", "W", "E", "R"})
Config.CUSTOM:DropDown("SEVENTH", "7", 1, {"Q", "W", "E", "R"})
Config.CUSTOM:DropDown("EIGHTH", "8", 1, {"Q", "W", "E", "R"})
Config.CUSTOM:DropDown("NINTH", "9", 1, {"Q", "W", "E", "R"})
Config.CUSTOM:DropDown("TENTH", "10", 1, {"Q", "W", "E", "R"})
Config.CUSTOM:DropDown("ELEVENTH", "11", 1, {"Q", "W", "E", "R"})
Config.CUSTOM:DropDown("TWELFTH", "12", 1, {"Q", "W", "E", "R"})
Config.CUSTOM:DropDown("THIRTEENTH", "13", 1, {"Q", "W", "E", "R"})
Config.CUSTOM:DropDown("FOURTEENTH", "14", 1, {"Q", "W", "E", "R"})
Config.CUSTOM:DropDown("FIFTEENTH", "15", 1, {"Q", "W", "E", "R"})
Config.CUSTOM:DropDown("SIXTEENTH", "16", 1, {"Q", "W", "E", "R"})
Config.CUSTOM:DropDown("SEVENTEENTH", "17", 1, {"Q", "W", "E", "R"})
Config.CUSTOM:DropDown("EIGHTEENTH", "18", 1, {"Q", "W", "E", "R"})

local TIMER = 0
local RQWE = {_Q,_W,_E,_Q,_Q,_R,_Q,_W,_Q,_W,_R,_W,_W,_E,_E,_R,_E,_E}
local RQEW = {_Q,_E,_W,_Q,_Q,_R,_Q,_E,_Q,_E,_R,_E,_E,_W,_W,_R,_W,_W}
local RWQE = {_W,_Q,_E,_W,_W,_R,_W,_Q,_W,_Q,_R,_Q,_Q,_E,_E,_R,_E,_E}
local RWEQ = {_W,_E,_Q,_W,_W,_R,_W,_E,_W,_E,_R,_E,_E,_Q,_Q,_R,_Q,_Q}
local REQW = {_E,_Q,_W,_E,_E,_R,_E,_Q,_E,_Q,_R,_Q,_Q,_W,_W,_R,_W,_W}
local REWQ = {_E,_W,_Q,_E,_E,_R,_E,_W,_E,_W,_R,_W,_W,_Q,_Q,_R,_Q,_Q}

OnTick(function (myHero)
        if GetTickCount() > TIMER + 1000 then
                local CASE = Config.SWITCH:Value()
                local LEVEL = GetLevel(myHero)
                local PLUS = GetCastLevel(myHero, _Q) + GetCastLevel(myHero, _W) + GetCastLevel(myHero, _E) + GetCastLevel(myHero, _R)
                if LEVEL > PLUS and LEVEL >= Config.START:Value() then
                        if CASE == 1 then
                                if LEVEL == 1 then
                                        LevelCustomSpell(Config.CUSTOM.FIRST:Value())
                                elseif LEVEL == 2 then
                                        LevelCustomSpell(Config.CUSTOM.SECOND:Value())
                                elseif LEVEL == 3 then
                                        LevelCustomSpell(Config.CUSTOM.THIRD:Value())
                                elseif LEVEL == 4 then
                                        LevelCustomSpell(Config.CUSTOM.FOURTH:Value())
                                elseif LEVEL == 5 then
                                        LevelCustomSpell(Config.CUSTOM.FIFTH:Value())
                                elseif LEVEL == 6 then
                                        LevelCustomSpell(Config.CUSTOM.SIXTH:Value())
                                elseif LEVEL == 7 then
                                        LevelCustomSpell(Config.CUSTOM.SEVENTH:Value())
                                elseif LEVEL == 8 then
                                        LevelCustomSpell(Config.CUSTOM.EIGHTH:Value())
                                elseif LEVEL == 9 then
                                        LevelCustomSpell(Config.CUSTOM.NINTH:Value())
                                elseif LEVEL == 10 then
                                        LevelCustomSpell(Config.CUSTOM.TENTH:Value())
                                elseif LEVEL == 11 then
                                        LevelCustomSpell(Config.CUSTOM.ELEVENTH:Value())
                                elseif LEVEL == 12 then
                                        LevelCustomSpell(Config.CUSTOM.TWELFTH:Value())
                                elseif LEVEL == 13 then
                                        LevelCustomSpell(Config.CUSTOM.THIRTEENTH:Value())
                                elseif LEVEL == 14 then
                                        LevelCustomSpell(Config.CUSTOM.FOURTEENTH:Value())
                                elseif LEVEL == 15 then
                                        LevelCustomSpell(Config.CUSTOM.FIFTEENTH:Value())
                                elseif LEVEL == 16 then
                                        LevelCustomSpell(Config.CUSTOM.SIXTEENTH:Value())
                                elseif LEVEL == 17 then
                                        LevelCustomSpell(Config.CUSTOM.SEVENTEENTH:Value())
                                else
                                        LevelCustomSpell(Config.CUSTOM.EIGHTEENTH:Value())
                                end
                        elseif CASE == 2 then
                                LevelSpell(RQWE[LEVEL])
                        elseif CASE == 3 then
                                LevelSpell(RQEW[LEVEL])
                        elseif CASE == 4 then
                                LevelSpell(RWQE[LEVEL])
                        elseif CASE == 5 then
                                LevelSpell(RWEQ[LEVEL])
                        elseif CASE == 6 then
                                LevelSpell(REQW[LEVEL])
                        else
                                LevelSpell(REWQ[LEVEL])
                        end
                end
                TIMER = GetTickCount()
        end
end)

function LevelCustomSpell(num)
        if num == 1 then
                LevelSpell(_Q)
        elseif num == 2 then
                LevelSpell(_W)
        elseif num == 3 then
                LevelSpell(_E)
        else
                LevelSpell(_R)
        end
end
