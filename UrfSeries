last = 0
Renemies = 0

Config = MenuConfig("GSO", "GamSterOn Xin Zhao")
Config:Menu("h", "Hotkeys")
Config.h:KeyBinding("co", "Combo", 32)

OnTick(function (myHero)
    if Config.h.co:Value() then
        if Ready(_E) then if SpellTarget(700, true) ~= nil then if Ready(_Q) then CastSpell(_Q) end if Ready(_W) then CastSpell(_W) end CastTargetSpell(SpellTarget(700, true), _E) end end
        if AATarget() ~= nil and GetTickCount() > last then AttackUnit(AATarget()) else MoveToXYZ(GetMousePos()) end
        if Ready(_Q) then if SpellTarget(GetRange(myHero), true) ~= nil then CastSpell(_Q) end end
        if Ready(_W) then if SpellTarget(GetRange(myHero), true) ~= nil then CastSpell(_W) end end
        if Ready(_R) then if RTarget() ~= nil and Renemies > 1 then CastSpell(_R) end end
    end
end)

OnSpellCast(function(spell)
    if spell.spellID == _Q then
        last = 0
    end
end)

OnProcessSpellComplete(function(unit,spell)
    if unit.isMe and ( spell.name:lower():find("attack") or spell.name == "XenZhaoThrust" or spell.name == "XenZhaoThrust2" or spell.name == "XenZhaoThrust3" ) then
        afterattack = true
        local speed = GetAttackSpeed(myHero) * GetBaseAttackSpeed(myHero)
        last = GetTickCount() + ( 1000 / speed ) - ( 60 / speed )
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
    for a, enemy in ipairs(GetEnemyHeroes()) do
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
    for a, enemy in ipairs(GetEnemyHeroes()) do
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

function RTarget()
    local t1, t2, t3, t4, t5 = nil, nil, nil, nil, nil
    local count, c1, c2, c3, c4, c5 = 0, 0, 0, 0, 0, 0
    local tr1, tr2, tr3, tr4, tr5 = false, false, false, false, false
    for a, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy, 200) then
            count = count + 1
            if a == 1 then t1 = enemy tr1 = true c1 = ComputeTS(enemy, true) end
            if a == 2 then if not tr1 then t1 = enemy tr1 = true c1 = ComputeTS(enemy, true) else t2 = enemy tr2 = true c2 = ComputeTS(enemy, true) end end
            if a == 3 then if not tr1 then t1 = enemy tr1 = true c1 = ComputeTS(enemy, true) elseif not tr2 then t2 = enemy tr2 = true c2 = ComputeTS(enemy, true) else t3 = enemy tr3 = true c3 = ComputeTS(enemy, true) end end
            if a == 4 then if not tr1 then t1 = enemy tr1 = true c1 = ComputeTS(enemy, true) elseif not tr2 then t2 = enemy tr2 = true c2 = ComputeTS(enemy, true) elseif not tr3 then t3 = enemy tr3 = true c3 = ComputeTS(enemy, true) else t4 = enemy tr4 = true c4 = ComputeTS(enemy, true) end end
            if a == 5 then if not tr1 then t1 = enemy tr1 = true c1 = ComputeTS(enemy, true) elseif not tr2 then t2 = enemy tr2 = true c2 = ComputeTS(enemy, true) elseif not tr3 then t3 = enemy tr3 = true c3 = ComputeTS(enemy, true) elseif not tr4 then t4 = enemy tr4 = true c4 = ComputeTS(enemy, true) else t5 = enemy  tr5 = true c5 = ComputeTS(enemy, true) end end
        end
    end
    Renemies = count
    if count == 1 then return t1 end
    if count == 2 then if c1 < c2 then return t1 else return t2 end end
    if count == 3 then  if c1 < c2 and c1 < c3 then return t1 elseif c2  < c1 and c2 < c3 then return t2 else return t3 end end
    if count == 4 then if c1 < c2 and c1 < c3 and c1 < c4 then return t1 elseif c2  < c1 and c2 < c3 and c2 < c4 then return t2 elseif c3  < c1 and c3 < c2 and c3 < c4 then return t3 else return t4 end end
    if count == 5 then if c1 < c2 and c1 < c3 and c1 < c4 and c1 < c5 then return t1 elseif c2  < c1 and c2 < c3 and c2 < c4 and c2 < c5 then return t2 elseif c3  < c1 and c3 < c2 and c3 < c4 and c3 < c5 then return t3 elseif c4  < c1 and c4 < c2 and c4 < c3 and c4 < c5 then return t4 else return t5 end end
    return nil
end
