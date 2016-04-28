local AllyTeam = GetTeam(myHero)

local ImmobileBuffs  = {}

OnLoad(function()
        ImmobileBuffs = { [GetBuffTypeList().Stun] = true, [GetBuffTypeList().Taunt] = true, [GetBuffTypeList().Snare] = true, [GetBuffTypeList().Fear] = true, [GetBuffTypeList().Charm] = true, [GetBuffTypeList().Suppression] = true, [GetBuffTypeList().Flee] = true, [GetBuffTypeList().Knockup] = true, [GetBuffTypeList().Knockback] = true }
end)

local WaypointDataBase = {}

local UtilsDataBase = {}

local ObjectDataBase =
{
        Minions =
        {
                Enemies ={},
                Allies = {},
                Jungle = {}
        },
        Heroes =
        {
                Enemies = {},
                Allies = {}
        },
        Turrets =
        {
                Enemies = {},
                Allies = {}
        }
}

OnCreateObj(function(o)
        local name = GetObjectBaseName(o)
        if AllyTeam == 100 then
                if name:find("Minion_T200") then
                        table.insert(ObjectDataBase.Minions.Enemies, o)
                end
        else
                if name:find("Minion_T100") then
                        table.insert(ObjectDataBase.Minions.Enemies, o)
                end
        end
end)

OnDeleteObj(function(o)
        local id = GetNetworkID(o)
        if WaypointDataBase[id] then
                WaypointDataBase[id] = nil
        end
        if UtilsDataBase[id] then
                UtilsDataBase[id] = nil
        end
        local count = #ObjectDataBase.Minions.Enemies
        for i = 1, count do
                if o == ObjectDataBase.Minions.Enemies[i] then
                        table.remove(ObjectDataBase.Minions.Enemies, i)
                        break
                end
        end
end)

OnObjectLoad(function(o)
        if GetObjectType(o) == Obj_AI_Hero then
                if GetTeam(o) == AllyTeam then
                        Insert(ObjectDataBase.Heroes.Allies, o)
                else
                        Insert(ObjectDataBase.Heroes.Enemies, o)
                end
        end
        if GetObjectType(o) == Obj_AI_Turret then
                if GetTeam(o) == AllyTeam then
                        table.insert(ObjectDataBase.Turrets.Allies, o)
                else
                        table.insert(ObjectDataBase.Turrets.Enemies, o)
                end
        end
end)

function Insert(t, o)
        table.insert(t, o)
        WaypointDataBase[GetNetworkID(o)] =
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
        UtilsDataBase[GetNetworkID(o)] =
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

------------------------BLITZ
last = 0
isattacking = false
windup = 0

Config = MenuConfig("GSO", "GamSterOn Blitzcrank")
Config:Menu("h", "Hotkeys")
Config.h:KeyBinding("co", "Combo", 32)

OnTick(function (myHero)
        if isattacking and GetTickCount() > windup + 100 then
                isattacking = false
        end
        if Config.h.co:Value() then
                local aat = AATarget()
                if AATarget() ~= nil and GetTickCount() > last then
                        AttackUnit(aat)
                elseif not isattacking then
                        MoveToXYZ(GetMousePos())
                end
                if Ready(_Q) then
                        local t = SpellTarget(920, false)
                        if t ~= nil then
                                local pos = GetPos(myHero, t, 3, 920, 1800, 0.25, 120)
                                if pos and pos.x ~= 0 then
                                        CastSkillShot(_Q, pos)
                                end
                        end
                end
                if Ready(_E) then
                        local t = SpellTarget(350, false)
                        if t ~= nil then
                                CastSpell(_E) 
                        end
                end
                if Ready(_R) then
                        local t = SpellTarget(600, false)
                        if t ~= nil then
                                CastSpell(_R) 
                        end
                end
        end
end)

OnSpellCast(function(spell)
        if spell.spellID == _E then
                last = 0
        end
end)

OnProcessSpellComplete(function(unit,spell)
        if unit.isMe and spell.name:lower():find("attack") then
                local speed = GetAttackSpeed(myHero) * GetBaseAttackSpeed(myHero)
                last = GetTickCount() + ( 1000 / speed ) - ( 60 / speed )
                isattacking = false
        end
end)

function ComputeTS(unit, AD)
        if AD then return GetCurrentHP(unit) * ( GetArmor(unit) / ( GetArmor(unit) + 100 ) ) - ( ( GetBaseDamage(unit) + GetBonusDmg(unit) ) * GetAttackSpeed(myHero) * GetBaseAttackSpeed(myHero) ) - GetBonusAP(unit) end
        return GetCurrentHP(unit) * ( GetMagicResist(unit) / ( GetMagicResist(unit) + 100 ) ) - ( ( GetBaseDamage(unit) + GetBonusDmg(unit) ) * GetAttackSpeed(myHero) * GetBaseAttackSpeed(myHero) ) - GetBonusAP(unit)
end

function AATarget()
    local t1, t2, t3, t4, t5 = nil, nil, nil, nil, nil
    local count, c1, c2, c3, c4, c5 = 0, 0, 0, 0, 0, 0
    local tr1, tr2, tr3, tr4, tr5 = false, false, false, false, false
    for a, enemy in ipairs(ObjectDataBase.Heroes.Enemies) do
        if ValidTarget(enemy, GetRange(myHero)+GetHitBox(myHero)+GetHitBox(enemy)) then
            count = count + 1
            if a == 1 then t1 = enemy tr1 = true c1 = ComputeTS(enemy, true) end
            if a == 2 then if not tr1 then t1 = enemy tr1 = true c1 = ComputeTS(enemy, true) else t2 = enemy tr2 = true c2 = ComputeTS(enemy, true) end end
            if a == 3 then if not tr1 then t1 = enemy tr1 = true c1 = ComputeTS(enemy, true) elseif not tr2 then t2 = enemy tr2 = true c2 = ComputeTS(enemy, true) else t3 = enemy tr3 = true c3 = ComputeTS(enemy, true) end end
            if a == 4 then if not tr1 then t1 = enemy tr1 = true c1 = ComputeTS(enemy, true) elseif not tr2 then t2 = enemy tr2 = true c2 = ComputeTS(enemy, true) elseif not tr3 then t3 = enemy tr3 = true c3 = ComputeTS(enemy, true) else t4 = enemy tr4 = true c4 = ComputeTS(enemy, true) end end
            if a == 5 then if not tr1 then t1 = enemy tr1 = true c1 = ComputeTS(enemy, true) elseif not tr2 then t2 = enemy tr2 = true c2 = ComputeTS(enemy, true) elseif not tr3 then t3 = enemy tr3 = true c3 = ComputeTS(enemy, true) elseif not tr4 then t4 = enemy tr4 = true c4 = ComputeTS(enemy, true) else t5 = enemy  tr5 = true c5 = ComputeTS(enemy, true) end end
        end
    end
    if count == 1 then return t1 end
    if count == 2 then if c1 < c2 then return t1 else return t2 end end
    if count == 3 then  if c1 < c2 and c1 < c3 then return t1 elseif c2  < c1 and c2 < c3 then return t2 else return t3 end end
    if count == 4 then if c1 < c2 and c1 < c3 and c1 < c4 then return t1 elseif c2  < c1 and c2 < c3 and c2 < c4 then return t2 elseif c3  < c1 and c3 < c2 and c3 < c4 then return t3 else return t4 end end
    if count == 5 then if c1 < c2 and c1 < c3 and c1 < c4 and c1 < c5 then return t1 elseif c2  < c1 and c2 < c3 and c2 < c4 and c2 < c5 then return t2 elseif c3  < c1 and c3 < c2 and c3 < c4 and c3 < c5 then return t3 elseif c4  < c1 and c4 < c2 and c4 < c3 and c4 < c5 then return t4 else return t5 end end
    return nil
end

function SpellTarget(Range, AD)
    local t1, t2, t3, t4, t5 = nil, nil, nil, nil, nil
    local count, c1, c2, c3, c4, c5 = 0, 0, 0, 0, 0, 0
    local tr1, tr2, tr3, tr4, tr5 = false, false, false, false, false
    for a, enemy in ipairs(ObjectDataBase.Heroes.Enemies) do
        if ValidTarget(enemy, Range) then
            count = count + 1
            if AD then
                if a == 1 then t1 = enemy tr1 = true c1 = ComputeTS(enemy, true) end
                if a == 2 then if not tr1 then t1 = enemy tr1 = true c1 = ComputeTS(enemy, true) else t2 = enemy tr2 = true c2 = ComputeTS(enemy, true) end end
                if a == 3 then if not tr1 then t1 = enemy tr1 = true c1 = ComputeTS(enemy, true) elseif not tr2 then t2 = enemy tr2 = true c2 = ComputeTS(enemy, true) else t3 = enemy tr3 = true c3 = ComputeTS(enemy, true) end end
                if a == 4 then if not tr1 then t1 = enemy tr1 = true c1 = ComputeTS(enemy, true) elseif not tr2 then t2 = enemy tr2 = true c2 = ComputeTS(enemy, true) elseif not tr3 then t3 = enemy tr3 = true c3 = ComputeTS(enemy, true) else t4 = enemy tr4 = true c4 = ComputeTS(enemy, true) end end
                if a == 5 then if not tr1 then t1 = enemy tr1 = true c1 = ComputeTS(enemy, true) elseif not tr2 then t2 = enemy tr2 = true c2 = ComputeTS(enemy, true) elseif not tr3 then t3 = enemy tr3 = true c3 = ComputeTS(enemy, true) elseif not tr4 then t4 = enemy tr4 = true c4 = ComputeTS(enemy, true) else t5 = enemy  tr5 = true c5 = ComputeTS(enemy, true) end end
            else
                if a == 1 then t1 = enemy tr1 = true c1 = ComputeTS(enemy, false) end
                if a == 2 then if not tr1 then t1 = enemy tr1 = true c1 = ComputeTS(enemy, false) else t2 = enemy tr2 = true c2 = ComputeTS(enemy, false) end end
                if a == 3 then if not tr1 then t1 = enemy tr1 = true c1 = ComputeTS(enemy, false) elseif not tr2 then t2 = enemy tr2 = true c2 = ComputeTS(enemy, false) else t3 = enemy tr3 = true c3 = ComputeTS(enemy, false) end end
                if a == 4 then if not tr1 then t1 = enemy tr1 = true c1 = ComputeTS(enemy, false) elseif not tr2 then t2 = enemy tr2 = true c2 = ComputeTS(enemy, false) elseif not tr3 then t3 = enemy tr3 = true c3 = ComputeTS(enemy, false) else t4 = enemy tr4 = true c4 = ComputeTS(enemy, false) end end
                if a == 5 then if not tr1 then t1 = enemy tr1 = true c1 = ComputeTS(enemy, false) elseif not tr2 then t2 = enemy tr2 = true c2 = ComputeTS(enemy, false) elseif not tr3 then t3 = enemy tr3 = true c3 = ComputeTS(enemy, false) elseif not tr4 then t4 = enemy tr4 = true c4 = ComputeTS(enemy, false) else t5 = enemy  tr5 = true c5 = ComputeTS(enemy, false) end end
            end
        end
    end
    if count == 1 then return t1 end
    if count == 2 then if c1 < c2 then return t1 else return t2 end end
    if count == 3 then  if c1 < c2 and c1 < c3 then return t1 elseif c2  < c1 and c2 < c3 then return t2 else return t3 end end
    if count == 4 then if c1 < c2 and c1 < c3 and c1 < c4 then return t1 elseif c2  < c1 and c2 < c3 and c2 < c4 then return t2 elseif c3  < c1 and c3 < c2 and c3 < c4 then return t3 else return t4 end end
    if count == 5 then if c1 < c2 and c1 < c3 and c1 < c4 and c1 < c5 then return t1 elseif c2  < c1 and c2 < c3 and c2 < c4 and c2 < c5 then return t2 elseif c3  < c1 and c3 < c2 and c3 < c4 and c3 < c5 then return t3 elseif c4  < c1 and c4 < c2 and c4 < c3 and c4 < c5 then return t4 else return t5 end end
    return nil
end
------------------------

OnProcessSpellAttack(function(unit, aa)
        local id = GetNetworkID(unit)
        if UtilsDataBase[id] then
                UtilsDataBase[id].AACastDelay = aa.windUpTime
                UtilsDataBase[id].AALast = GetTickCount()
                UtilsDataBase[id].IsAttacking = true
        end
        if unit.isMe then
                isattacking = true
                windup = GetTickCount() + aa.windUpTime * 1000
        end
end)

OnProcessWaypoint(function(unit,waypoint)
        local id = GetNetworkID(unit)
        local ms = GetMoveSpeed(unit)
        if WaypointDataBase[id] then
                if waypoint.index == 2 then
                        WaypointDataBase[id].third = WaypointDataBase[id].second
                        WaypointDataBase[id].second = WaypointDataBase[id].last
                        WaypointDataBase[id].last.from = waypoint.position
                        WaypointDataBase[id].last.time = GetTickCount()
                end
                if waypoint.index == 1 then
                        if GetTickCount() < WaypointDataBase[id].last.time + 25 then
                                UtilsDataBase[id].CanMove = true
                                local t = waypoint.position
                                WaypointDataBase[id].last.to = t
                                local f = WaypointDataBase[id].last.from
                                local a = t.x - f.x
                                local b = t.z - f.z
                                local c = ComputeDistance(a, b)
                                WaypointDataBase[id].last.dist = c
                                WaypointDataBase[id].last.dir = { x = a/c, z = b/c }
                                UtilsDataBase[id].IsMoving = true
                        else
                                UtilsDataBase[id].CanMove = false
                                UtilsDataBase[id].LastStopMoveTime = GetTickCount()
                                UtilsDataBase[id].IsMoving = false
                        end
                end
        end
end)

function ComputeDirection(a, b)
        local c = ComputeDistance(a, b)
        return { x = a/c, z = b/c }
end

function ComputeDistance(a, b)
        return math.sqrt( a^2 + b^2 )
end

OnUpdateBuff(function(unit, buff)
        local id = GetNetworkID(unit)
        if WaypointDataBase[id] and ImmobileBuffs[buff.Type] then
                table.insert(UtilsDataBase[id].Immobile, { StartTime = GetTickCount(), EndTime = buff.ExpireTime } )
                UtilsDataBase[id].IsImmobile = true
        end
end)

OnRemoveBuff(function(unit, buff)
        local id = GetNetworkID(unit)
        if UtilsDataBase[id] then
                for i, b in ipairs(UtilsDataBase[id].Immobile) do
                        if b.EndTime == buff.ExpireTime then
                                table.remove(UtilsDataBase[id].Immobile, i)
                                break
                        end
                end
        end
end)

function GetPos(startpos, endpos, hitchance, range, speed, delay, width)
        local id = GetNetworkID(endpos)
        local way = WaypointDataBase[id]
        local util = UtilsDataBase[id]
        if WaypointDataBase[id] and WaypointDataBase[id].third.to then
                local ax = startpos.pos.x
                local az = startpos.pos.z
                local bx = endpos.pos.x
                local bz = endpos.pos.z
                for m, minion in ipairs(ObjectDataBase.Minions.Enemies) do
                        local hp = GetCurrentHP(minion)
                        if hp ~= 0 then
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
                                if ac < ab + 250 then
                                        if bc < ab + 250 then
                                                local dist_obj_line = math.abs(a * c + b * d) / ab
                                                local compute_max_obj_dist = width/2 + cbb/2
                                                if dist_obj_line < compute_max_obj_dist then
                                                        return { x = 0 }
                                                end
                                        end
                                end
                        end
                end
                local cx = WaypointDataBase[id].last.to.x
                local cz = WaypointDataBase[id].last.to.z
                local bc = WaypointDataBase[id].last.dist
                local vx = WaypointDataBase[id].last.dir.x
                local vz = WaypointDataBase[id].last.dir.z
                local bv = GetMoveSpeed(endpos)
                local array = #UtilsDataBase[id].Immobile
                if UtilsDataBase[id].IsImmobile then
                        local array = #UtilsDataBase[id].Immobile
                        if array ~= 0 then
                                local max = UtilsDataBase[id].Immobile[array].EndTime
                                local tick = UtilsDataBase[id].Immobile[array].StartTime
                                if array > 1 then
                                        for i = array-1, 1, - 1 do
                                                if UtilsDataBase[id].Immobile[i].EndTime>max then
                                                        max = UtilsDataBase[id].Immobile[i].EndTime
                                                        tick = UtilsDataBase[id].Immobile[i].StartTime
                                                end
                                        end
                                end
                                if max ~= 0 then
                                        if GetTickCount() < tick + max - max/10*hitchance then
                                                local dist = ComputeDistance(myHero.pos.x - bx, myHero.pos.z - bz)
                                                if dist < range then
                                                        WaypointDataBase[id].last.timeto = dist / bv * 1000
                                                        return endpos.pos
                                                end
                                        else
                                                UtilsDataBase[id].IsImmobile = false
                                        end
                                end
                        else
                                UtilsDataBase[id].IsImmobile = false
                        end
                end
                if UtilsDataBase[id].IsAttacking then
                        local lastaa = UtilsDataBase[id].AALast
                        local windup = UtilsDataBase[id].AACastDelay
                        local dist = ComputeDistance(myHero.pos.x - bx, myHero.pos.z - bz)
                        if GetTickCount() < lastaa + windup - windup/10*hitchance then
                                WaypointDataBase[id].last.timeto = dist / bv * 1000
                                if dist < range then
                                        return endpos.pos
                                end
                        else
                                UtilsDataBase[id].IsAttacking = false
                        end
                end
                if UtilsDataBase[id].IsMoving and UtilsDataBase[id].CanMove then
                        if bx == cx and bz == cz then
                                UtilsDataBase[id].LastStopMoveTime = GetTickCount()
                                UtilsDataBase[id].IsMoving = false
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
                                if GetTickCount() < WaypointDataBase[id].last.time + 250/hitchance or GetTickCount() > WaypointDataBase[id].last.time + 2000 then
                                        if bp > bc then
                                                local dist = ComputeDistance(myHero.pos.x - cx, myHero.pos.z - cz)
                                                if dist< range then
                                                        WaypointDataBase[id].last.timeto = dist / bv * 1000
                                                        return way.last.to
                                                end
                                        else
                                                local dist = ComputeDistance(myHero.pos.x - px, myHero.pos.z - pz) 
                                                if dist < range then
                                                        WaypointDataBase[id].last.timeto = dist / bv * 1000
                                                        return { x = px, y = 0, z = pz }
                                                end
                                        end
                                end
                        end
                else
                        local dist = ComputeDistance(myHero.pos.x - bx, myHero.pos.z - bz)
                        if dist < range then
                                WaypointDataBase[id].last.timeto = dist / bv * 1000
                                if GetTickCount() < UtilsDataBase[id].LastStopMoveTime + 250/hitchance then
                                        return endpos.pos
                                end
                        end
                end
        end
end
