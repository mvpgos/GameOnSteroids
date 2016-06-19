if myHero.charName ~= "Blitzcrank" then
  return 
end

BlockF7OrbWalk(true)

require 'OpenPredict'
if not FileExist(COMMON_PATH.."\\GPrediction.lua") then
        DownloadFileAsync("https://raw.githubusercontent.com/KeVuong/GoS/master/Common/GPrediction.lua", COMMON_PATH .. "GPrediction.lua", function() PrintChat("Download Completed, please 2x F6!") return end)
        return
end
require "GPrediction"
local GPred = _G.gPred

local Q = {range = 925, maxrange = 925, radius = 70 , speed = 1750, delay = 0.25, type = "line"}

-- G P R E D I C T I O N  C O L L I S I O N https://github.com/KeVuong/GoS/blob/master/Support%20Bundle.lua#L639
function MinionCollisitionCheck(pos)
        --local objects = {}
        local objects = 0
        for _,minion in pairs(minionManager.objects) do
                if minion.team ~= myHero.team and ValidTarget(minion,1200) then
                        local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(myHero.pos, pos, Vector(minion))
                        if isOnSegment and GetDistance(pointSegment,minion) < Q.radius + minion.boundingRadius then
                                --table.insert(objects,minion)
                                objects = objects + 1
                        end
                end
        end
        --return #objects > 0, objects
        return objects > 0
end
function HeroCollisitionCheck(pos, enemy)
        --local objects = {}
        local objects = 0
        for _,unit in pairs(GetEnemyHeroes()) do
                if unit ~= enemy and ValidTarget(unit,1200) then
                        local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(myHero.pos, pos, Vector(unit))
                        if isOnSegment and GetDistance(pointSegment,unit) < Q.radius + unit.boundingRadius then
                                --table.insert(objects,minion)
                                -- DEBUG PrintChat("G "..GetObjectName(unit))
                                objects = objects + 1
                        end
                end
        end
        --return #objects > 0, objects
        return objects > 0
end

-- U P D A T E
local ver = "1.91"
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

-- V A R I A B L E S
local UtilsManager = {}
local ImmobileBuffs  = {}
local WaypointManager = {}
local focus_target = nil

-- M E N U
Config = MenuConfig("GSO", "GamSterOn Blitzcrank")
Config:KeyBinding("combo", "Combo", 32)
Config:Menu("TS", "GamSterOn Target Selector")
Config.TS:Menu("focus", "Focus List")
Config.TS:ColorPick("color", "Selected Target Color", {255,255,0,0})
Config:Menu("PRED", "Prediction")
Config.PRED:DropDown("SWITCH", "Prediction Mode ->", 1, {"GamSterOn", "Open Predict", "GPrediction"})
Config.PRED:Slider("GSOHITCHANCE", "GamSterOn Hitchance", 3,1,10,1)
Config.PRED:Slider("OHITCHANCE", "Open Predict Hitchance", 4,1,10,1)
Config.PRED:Slider("GHITCHANCE", "GPrediction Hitchance", 3, 1,10,1)

-- O N  L O A D
OnLoad(function()
        for _,o in pairs(GetEnemyHeroes()) do
                local name = GetObjectName(o)
                local id = GetNetworkID(o)
                Config.TS.focus:Boolean(name, name, true)
                WaypointManager[id] =
                {
                        last =
                        {
                                dir = {},
                                time = 0,
                                from = {},
                                to = {},
                                dist = 0,
                                timeto = 0
                        },
                        second = {},
                        third = {}
                }
                UtilsManager[id] =
                {
                        CanMove = true,
                        IsMoving = false,
                        LastStopMoveTime = 0,
                        IsAttacking = false,
                        AALast = 0,
                        AACastDelay = 0,
                        IsImmobile = false,
                        Immobile = {}
                }
        end
        ImmobileBuffs =
        {
                [GetBuffTypeList().Stun] = true,
                [GetBuffTypeList().Taunt] = true,
                [GetBuffTypeList().Snare] = true,
                [GetBuffTypeList().Fear] = true,
                [GetBuffTypeList().Charm] = true,
                [GetBuffTypeList().Suppression] = true,
                [GetBuffTypeList().Flee] = true,
                [GetBuffTypeList().Knockup] = true,
                [GetBuffTypeList().Knockback] = true
        }
end)

-- O N  D R A W
OnDraw(function(myHero)
        if focus_target ~= nil then
                DrawCircle(focus_target.pos, 75, 3, 3, Config.TS.color:Value())
        end
end)

-- O N  P R O C E S S  W A Y P  O I N T
OnProcessWaypoint(function(unit,waypoint)
        local id = GetNetworkID(unit)
        local ms = GetMoveSpeed(unit)
        if WaypointManager[id] then
                if waypoint.index == 2 then
                        WaypointManager[id].third = WaypointManager[id].second
                        WaypointManager[id].second = WaypointManager[id].last
                        WaypointManager[id].last.from = waypoint.position
                        WaypointManager[id].last.time = GetTickCount()
                end
                if waypoint.index == 1 then
                        if GetTickCount() < WaypointManager[id].last.time + 25 then
                                UtilsManager[id].CanMove = true
                                local t = waypoint.position
                                WaypointManager[id].last.to = t
                                local f = WaypointManager[id].last.from
                                local a = t.x - f.x
                                local b = t.z - f.z
                                local c = ComputeDistance(a, b)
                                WaypointManager[id].last.dist = c
                                WaypointManager[id].last.dir = { x = a/c, z = b/c }
                                UtilsManager[id].IsMoving = true
                        else
                                UtilsManager[id].CanMove = false
                                UtilsManager[id].LastStopMoveTime = GetTickCount()
                                UtilsManager[id].IsMoving = false
                        end
                end
        end
end)

-- O N  P R O C E S S  S P E L L  A T T A C K
OnProcessSpellAttack(function(unit, aa)
        local id = GetNetworkID(unit)
        if UtilsManager[id] then
                UtilsManager[id].AACastDelay = aa.windUpTime * 1000
                UtilsManager[id].AALast = GetTickCount()
                UtilsManager[id].IsAttacking = true
        end
end)

-- O N  U P D A T E  B U F F
OnUpdateBuff(function(unit, buff)
        local id = GetNetworkID(unit)
        if WaypointManager[id] then
                local type = buff.Type
                if ImmobileBuffs[type] then
                        table.insert(UtilsManager[id].Immobile, { StartTime = GetTickCount(), EndTime = buff.ExpireTime } )
                        UtilsManager[id].IsImmobile = true
                end
        end
end)

-- O N  R E M O V E  B U F F
OnRemoveBuff(function(unit, buff)
        local id = GetNetworkID(unit)
        local et = buff.ExpireTime
        if UtilsManager[id] then
                for i, b in pairs(UtilsManager[id].Immobile) do
                        if b.EndTime == et then
                                table.remove(UtilsManager[id].Immobile, i)
                                break
                        end
                end
        end
end)

-- O N  W N D  M S G
OnWndMsg(function(msg, key)
        if msg == 513 then
                local count = 0
                local target = nil
                for _,enemy in pairs(GetEnemyHeroes()) do
                        if ValidTarget(enemy, 9999) then
                                if ComputeDistance(enemy.pos.x - GetMousePos().x, enemy.pos.z - GetMousePos().z) < 150 then
                                        count = count + 1
                                        target = enemy
                                end
                        end
                end
                if count == 1 then
                        focus_target = target
                elseif count == 0 then
                        focus_target = nil
                end
        end
end)

-- O N  S P E L L  C A S T
OnSpellCast(function(Spell)
        if Spell.spellID == _Q then
                if Ready(_E) then
                        CastSpell(_E)
                end
        end
end)

-- O N  T I C K
OnTick(function (myHero)
        if Config.combo:Value() then
                if Ready(_Q) then
                        local qt = GetSpellTarget(920)
                        if qt ~= nil then
                                local case = Config.PRED.SWITCH:Value()
                                if case == 1 then
                                        local pos = GetPos(myHero, qt, 920, 1700, 0.25, 120)
                                        if pos and pos.x ~= 0 then
                                                CastSkillShot(_Q, pos)
                                        end
                                elseif case == 2 then
                                        local pI = GetPrediction(qt, Q)
                                        local hitchance = Config.PRED.OHITCHANCE:Value() * 0.1
                                        if pI and pI.hitChance >= hitchance and not pI:mCollision(0) and not pI:hCollision(0) then
                                                CastSkillShot(_Q, pI.castPos)
                                        end
                                else
                                        local pI = GPred:GetPrediction(qt,myHero,Q)
                                        local hitchance = Config.PRED.GHITCHANCE:Value()
                                        if pI and pI.HitChance >= hitchance then
                                              local mcol = MinionCollisitionCheck(pI.CastPosition)
                                              local hcol = HeroCollisitionCheck(pI.CastPosition, qt)
                                              if not mcol and not hcol then
                                                      CastSkillShot(_Q, pI.CastPosition)
                                              end
                                        end
                                end
                        end
                end
                if Ready(_E) then
                        SetAttackValue(true)
                        local et = GetSpellTarget(300)
                        if et ~= nil then
                                CastSpell(_E)
                        end
                else
                        SetAttackValue(false)
                end
                if Ready(_R) then
                        local rt = GetSpellTarget(550)
                        if rt ~= nil then
                                CastSpell(_R)
                        end
                end
        else
                SetAttackValue(false)
        end
end)

-- S E T  A T T A C K  V A L U E
function SetAttackValue(check)
        if GoSWalkLoaded then
                if check == true then
                        -- DEBUG PrintChat("t GosWalk")
                        GoSWalk:EnableAttack(false)
                else
                        -- DEBUG PrintChat("f GosWalk")
                        GoSWalk:EnableAttack(true)
                end
        elseif IOW_Loaded then
                if check == true then
                        -- DEBUG PrintChat("t IOW")
                        IOW.attacksEnabled = false
                else
                        -- DEBUG PrintChat("f IOW")
                        IOW.attacksEnabled = true
                end
        elseif DAC_Loaded then
                if check == true then
                        -- DEBUG PrintChat("t DAC")
                        DAC.attacksEnabled = false
                else
                        -- DEBUG PrintChat("f DAC")
                        DAC.attacksEnabled = true
                end
        elseif PW_Loaded then
                if check == true then
                        -- DEBUG PrintChat("t PW")
                        PW.attacksEnabled = false
                else
                        -- DEBUG PrintChat("f PW")
                        PW.attacksEnabled = true
                end
        end
end

-- D I S T A N C E-
function ComputeDistance(a, b)
        return math.sqrt( a^2 + b^2 )
end

-- D I R E C T I O N
function ComputeDirection(a, b)
        local c = ComputeDistance(a, b)
        return { x = a/c, z = b/c }
end

-- A P  S P E L L  T A R G E T
function GetSpellTarget(range)
        local selectedtarget = GetSelectedTarget()
        if selectedtarget ~= nil then
                if GetCurrentHP(focus_target) == 0 or ComputeDistance(focus_target.pos.x - myHero.pos.x, focus_target.pos.z - myHero.pos.z) > 3000 then
                        focus_target = nil
                end
                if ValidTarget(focus_target, range) then
                        return selectedtarget
                end
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

-- S E L E C T E D  T A R G E T
function GetSelectedTarget()
        local target = nil
        if focus_target ~= nil then
                target = focus_target
        end
        return target
end

-- P R E D I C T I O N
function GetPos(startpos, endpos, range, speed, delay, width)
        local hitchance = Config.PRED.GSOHITCHANCE:Value()
        local id = GetNetworkID(endpos)
        local way = WaypointManager[id]
        local util = UtilsManager[id]
        if WaypointManager[id] and WaypointManager[id].third.to then
                local ax = startpos.pos.x
                local az = startpos.pos.z
                local bx = endpos.pos.x
                local bz = endpos.pos.z
                for m, minion in pairs(minionManager.objects) do
                        if minion.team == MINION_ENEMY and ValidTarget(minion, 1000) then
                                local cx = minion.pos.x
                                local cz = minion.pos.z
                                local cbb = GetHitBox(minion)
                                local a = bz-az
                                local b = bx-ax
                                local c = ax-cx
                                local d = cz-az
                                local ab = ComputeDistance(b,a)
                                local ac = ComputeDistance(c,az-cz)
                                local bc = ComputeDistance(bx-cx,bz-cz)
                                if ac < ab + 100 then
                                        if bc < ab + 100 then
                                                local dist_obj_line = math.abs(a * c + b * d) / ab
                                                local compute_max_obj_dist = width/2 + cbb/2 + 50
                                                if dist_obj_line < compute_max_obj_dist then
                                                        -- DEBUG PrintChat("GSO "..GetObjectName(minion))
                                                        return { x = 0 }
                                                end
                                        end
                                end
                        end
                end
                for _,unit in pairs(GetEnemyHeroes()) do
                        if unit ~= endpos and ValidTarget(unit,1200) then
                                local cx = unit.pos.x
                                local cz = unit.pos.z
                                local cbb = GetHitBox(unit)
                                local a = bz-az
                                local b = bx-ax
                                local c = ax-cx
                                local d = cz-az
                                local ab = ComputeDistance(b,a)
                                local ac = ComputeDistance(c,az-cz)
                                local bc = ComputeDistance(bx-cx,bz-cz)
                                if ac < ab + 200 then
                                        if bc < ab + 200 then
                                                local dist_obj_line = math.abs(a * c + b * d) / ab
                                                local compute_max_obj_dist = width/2 + cbb/2 + 50
                                                if dist_obj_line < compute_max_obj_dist then
                                                        -- DEBUG PrintChat("GSO "..GetObjectName(unit))
                                                        return { x = 0 }
                                                end
                                        end
                                end
                        end
                end
                local cx = WaypointManager[id].last.to.x
                local cz = WaypointManager[id].last.to.z
                local bc = WaypointManager[id].last.dist
                local vx = WaypointManager[id].last.dir.x
                local vz = WaypointManager[id].last.dir.z
                local bv = GetMoveSpeed(endpos)
                local array = #UtilsManager[id].Immobile
                if UtilsManager[id].IsImmobile then
                        local array = #UtilsManager[id].Immobile
                        if array ~= 0 then
                                local max = UtilsManager[id].Immobile[array].EndTime
                                local tick = UtilsManager[id].Immobile[array].StartTime
                                if array > 1 then
                                        for i = array-1, 1, - 1 do
                                                if UtilsManager[id].Immobile[i].EndTime>max then
                                                        max = UtilsManager[id].Immobile[i].EndTime
                                                        tick = UtilsManager[id].Immobile[i].StartTime
                                                end
                                        end
                                end
                                if max ~= 0 then
                                        if GetTickCount() < tick + max - max/10*hitchance then
                                                local dist = ComputeDistance(myHero.pos.x - bx, myHero.pos.z - bz)
                                                if dist < range then
                                                        WaypointManager[id].last.timeto = dist / bv * 1000
                                                        return endpos.pos
                                                end
                                        else
                                                UtilsManager[id].IsImmobile = false
                                        end
                                end
                        else
                                UtilsManager[id].IsImmobile = false
                        end
                end
                if UtilsManager[id].IsAttacking then
                        local lastaa = UtilsManager[id].AALast
                        local windup = UtilsManager[id].AACastDelay
                        local dist = ComputeDistance(myHero.pos.x - bx, myHero.pos.z - bz)
                        if GetTickCount() < lastaa + windup - windup/10*hitchance then
                                if dist < range then
                                        WaypointManager[id].last.timeto = dist / bv * 1000
                                        return endpos.pos
                                end
                        else
                                UtilsManager[id].IsAttacking = false
                        end
                end
                if UtilsManager[id].IsMoving and UtilsManager[id].CanMove then
                        if bx == cx and bz == cz then
                                UtilsManager[id].LastStopMoveTime = GetTickCount()
                                UtilsManager[id].IsMoving = false
                        end
                        local ab = ComputeDistance(ax - bx, az - bz)
                        local hx = bx + ( vx * bv * ( delay + ab / speed ) )
                        local hz = bz + ( vz * bv * ( delay + ab / speed ) )
                        local ah = ComputeDistance(ax - hx, az - hz)
                        local ix = bx + ( vx * bv * ( delay + ah / speed ) )
                        local iz = bz + ( vz * bv * ( delay + ah / speed ) )
                        local ai = ComputeDistance(ax - ix, az - iz)
                        local jx = bx + ( vx * bv * ( delay + ai / speed ) )
                        local jz = bz + ( vz * bv * ( delay + ai / speed ) )
                        local aj = ComputeDistance(ax - jx, az - jz)
                        local bj = ComputeDistance(bx - jx, bz - jz)
                        local at = delay + aj / speed
                        local bt = bj / bv
                        if at - bt > -0.05 and at - bt < 0.05 then
                                local px = jx - ( vx * ( width/2 ) )
                                local pz = jz - ( vz * ( width/2 ) )
                                local bp = ComputeDistance(bx - px, bz - pz)
                                if GetTickCount() < WaypointManager[id].last.time + 250/hitchance or GetTickCount() > WaypointManager[id].last.time + 1000 then
                                        if bp > bc then
                                                local dist = ComputeDistance(myHero.pos.x - cx, myHero.pos.z - cz)
                                                if dist< range then
                                                        WaypointManager[id].last.timeto = dist / bv * 1000
                                                        return way.last.to
                                                end
                                        else
                                                local dist = ComputeDistance(myHero.pos.x - px, myHero.pos.z - pz) 
                                                if dist < range then
                                                        WaypointManager[id].last.timeto = dist / bv * 1000
                                                        return { x = px, y = 0, z = pz }
                                                end
                                        end
                                end
                        end
                else
                        local dist = ComputeDistance(myHero.pos.x - bx, myHero.pos.z - bz)
                        if dist < range then
                                if GetTickCount() < UtilsManager[id].LastStopMoveTime + 250/hitchance then
                                        WaypointManager[id].last.timeto = dist / bv * 1000
                                        return endpos.pos
                                end
                        end
                end
        end
end
