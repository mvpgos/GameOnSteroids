if myHero.charName ~= "Blitzcrank" then
  return
end

require 'OpenPredict'
if not FileExist(COMMON_PATH.."\\GPrediction.lua") then
        DownloadFileAsync("https://raw.githubusercontent.com/KeVuong/GoS/master/Common/GPrediction.lua", COMMON_PATH .. "GPrediction.lua", function() PrintChat("Download Completed, please 2x F6!") return end)
        return
end
require "GPrediction"
local GPred = _G.gPred

local ver = "2.04"
function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat("New version found! " .. data)
        PrintChat("Downloading update, please wait...")
        DownloadFileAsync("https://raw.githubusercontent.com/gamsteron/GameOnSteroids/master/Blitzcrank.lua", SCRIPT_PATH .. "Blitzcrank.lua", function() PrintChat("Update Complete, please 2x F6!") return end)
    else
        PrintChat(string.format("<font color='#b756c5'>GamSterOn </font>").."updated ! Version: "..ver)
    end
end
GetWebResultAsync("https://raw.githubusercontent.com/gamsteron/GameOnSteroids/master/Blitzcrank.version", AutoUpdate)

local focus_target = nil
local Q = {range = 925, maxrange = 925, radius = 70 , speed = 1750, delay = 0.25, type = "line", col = {"minion","champion"}}
local cane = 0
local canr = 0

Config = MenuConfig("GSO", "GamSterOn Blitzcrank")
Config:Menu("TS", "Target Selector")
Config.TS:Menu("focus", "Focus List")
Config.TS:ColorPick("color", "Selected Target Color", {255,255,0,0})
Config:Menu("CHECK", "Checks")
Config.CHECK:KeyBinding("combo", "Combo", 32)
Config.CHECK:Boolean("SEL", "Spells only on selected tar", false)
Config.CHECK:Boolean("Q", "UseQ", true)
Config.CHECK:Boolean("E", "UseE", true)
Config.CHECK:Boolean("R", "UseR", true)
Config.CHECK:Boolean("AUTOQ", "Auto Q", false)
Config.CHECK:Boolean("AUTOQSEL", "Auto Q only selected tar", false)
Config.CHECK:Boolean("DASH", "Auto Q on dash - GPred", true)
Config.CHECK:Boolean("EQ", "Cast E if grab", true)
Config.CHECK:Boolean("EAA", "Cast E if enemy in aa ran", true)
Config:Menu("PRED", "Prediction")
Config.PRED:DropDown("SWITCH", "Prediction Mode ->", 2, {"Open Predict", "GPrediction"})
Config.PRED:Slider("OHITCHANCE", "Open Predict Min. Hitchance", 3,2,5,1)
Config.PRED:Slider("GHITCHANCE", "GPrediction Min. Hitchance", 3, 2,3,1)

OnLoad(function()
        for _,o in pairs(GetEnemyHeroes()) do
                local name = GetObjectName(o)
                Config.TS.focus:Boolean(name, name, true)
        end
end)

OnTick(function (myHero)
        if Config.CHECK.E:Value() and Config.CHECK.EQ:Value() then
                if Ready(_E) and GetTickCount() > 500 + cane and GetTickCount() < 1000 + cane then
                        CastSpell(_E)
                end
        end
        if Config.CHECK.combo:Value() then
                if Config.CHECK.Q:Value() then
                        CastQ()
                end
                if Config.CHECK.E:Value() and Config.CHECK.EAA:Value() then
                        CastE()
                end
                if Config.CHECK.R:Value() and GetTickCount() > canr + 500 then
                        CastR()
                end
        else
                if Config.CHECK.Q:Value() then
                        if Config.CHECK.AUTOQ:Value() then
                                if Config.CHECK.AUTOQSEL:Value() then
                                        if focus_target ~= nil then
                                                CastQ()
                                        end
                                else
                                        CastQ()
                                end
                        end
                        if Config.CHECK.DASH:Value() then
                                AutoQ()
                        end
                end
        end
end)

-- C A S T  S P E L L S
function CastQ()
        if not Ready(_Q) then
                return
        end
        local case = Config.PRED.SWITCH:Value()
        local qt = GetSpellTarget(925)
        if qt == nil then
                return
        end
        if case == 1 then
                local hitchance = Config.PRED.OHITCHANCE:Value() * 0.1
                local pI = GetPrediction(qt, Q)
                if pI and pI.hitChance >= hitchance and not pI:mCollision(0) and not pI:hCollision(0) then
                        CastSkillShot(_Q, pI.castPos)
                        canr = GetTickCount()
                        if Config.CHECK.EQ:Value() then
                                cane = GetTickCount()
                        end
                end
                return
        end
        local hitchance = Config.PRED.GHITCHANCE:Value()
        local pI = GPred:GetPrediction(qt,myHero,Q, false, true)
        if pI and pI.HitChance >= hitchance then
                CastSkillShot(_Q, pI.CastPosition)
                canr = GetTickCount()
                if Config.CHECK.EQ:Value() then
                        cane = GetTickCount()
                end
        end
end
function AutoQ()
        if Config.PRED.SWITCH:Value() == 1 then
                return
        end
        if not Ready(_Q) then
                return
        end
        for _,enemy in pairs(GetEnemyHeroes()) do
                if ValidTarget(enemy, 1500) then
                        local pI = GPred:GetPrediction(enemy,myHero,Q, false, true)
                        if pI and pI.HitChance == 4 and ComputeDistance(pI.CastPosition.x - myHero.pos.x, pI.CastPosition.z - myHero.pos.z) < 900 then
                                CastSkillShot(_Q, pI.CastPosition)
                                canr = GetTickCount()
                                if Config.CHECK.EQ:Value() then
                                        cane = GetTickCount()
                                end
                        end
                end
        end
end
function CastE()
        if not Ready(_E) then
                return
        end
        local t = GetSpellTarget(325)
        if t == nil then
                return
        end
        CastSpell(_E)
end
function CastR()
        if not Ready(_R) then
                return
        end
        local t = GetSpellTarget(525)
        if t == nil then
                return
        end
        CastSpell(_R)
end

-- T A R G E T  S E L E C T O R
OnWndMsg(function(msg, key)
        if msg == 513 then
                local target = nil
                local dist = 1000
                for _,enemy in pairs(GetEnemyHeroes()) do
                        if ValidTarget(enemy, 9999) then
                                local d = ComputeDistance(enemy.pos.x - GetMousePos().x, enemy.pos.z - GetMousePos().z)
                                if  d < dist and d < 200 then
                                        dist = d
                                        target = enemy
                                end
                        end
                end
                focus_target = target
        end
end)
OnDraw(function(myHero)
        if focus_target ~= nil then
                DrawCircle(focus_target.pos, 75, 3, 3, Config.TS.color:Value())
        end
end)
function GetSpellTarget(range)
        if focus_target ~= nil then
                if not Config.CHECK.SEL:Value() and GetCurrentHP(focus_target) == 0 or ComputeDistance(focus_target.pos.x - myHero.pos.x, focus_target.pos.z - myHero.pos.z) > 3000 then
                        focus_target = nil
                end
                if ValidTarget(focus_target, range) then
                        return focus_target
                end
                return nil
        end
        if Config.CHECK.SEL:Value() then
                return nil
        end
        local dmg = 9999
        local target = nil
        for _,unit in pairs(GetEnemyHeroes()) do
                if Config.TS.focus[GetObjectName(unit)]:Value() and ValidTarget(unit, range) then
                        local hp = ( GetCurrentHP(unit) * ( GetMagicResist(unit) / ( GetMagicResist(unit) + 100 ) ) ) - ( ( GetBaseDamage(unit) + GetBonusDmg(unit) ) * GetAttackSpeed(myHero) * GetBaseAttackSpeed(myHero) ) - GetBonusAP(unit)
                        if hp < dmg then
                                dmg = hp
                                target = unit
                        end
                end
        end
        return target
end

-- U T I L I T I E S
function ComputeDistance(a, b)
        return math.sqrt( a^2 + b^2 )
end
