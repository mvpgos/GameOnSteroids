require 'OpenPredict'
require 'DamageLib'

local Q = {range = 860, delay = 0.26 , speed = 1700, radius = 60}
local W = {range = 585}
local E = {range = 585}
local summonerSpells = {ignite = {}, flash = {}, heal = {}, barrier = {}, smite = {}}
local igniteFound = false
local Qdamage = {60, 85, 110, 135, 160}
local Qdamagemana = {2, 2.5, 3, 3.5, 4}
local Wdamage = {80, 100, 120, 140, 160}
local Edamage = {36, 52, 68, 84, 100}
local CalcMagicDamage = function(self, t, dmg) if not dmg then dmg = self.totalDamage end local enemy = type(t) == "table" and t.object or t local armor = GetMagicResist(enemy) local perc = GetMagicPenPercent(self) local flat = GetMagicPenFlat(self) armor = (armor*(perc))-flat return (dmg*(armor >= 0 and (100/(100+armor)) or (2-(100/(100-armor))))) end
local PassiveBuff = 0
local Charged = false

local Menu = MenuConfig("Ryze", "Icy Ryze")
Menu:Menu("Combo", "Combo")
Menu.Combo:KeyBinding("c", "Hotkey", 32)
Menu.Combo:Boolean("useQ", "Use Q (Over Load)", true)
Menu.Combo:Boolean("useW", "Use W (Rune Prison)", true)
Menu.Combo:Boolean("useE", "Use E (Spell Flux)", true)
Menu.Combo:Boolean("useR", "Use R (Desperate Power)", true)
Menu.Combo:Boolean("useRww", "Only R if Target Is Rooted", true)
Menu:Menu("KillSteal", "Kill Steal")
Menu.KillSteal:Boolean("KS", "Kill Steal Enable", true)
Menu.KillSteal:Boolean("UseQ", "Use Q for KS", true)
Menu.KillSteal:Boolean("UseW", "Use W for KS", true)
Menu.KillSteal:Boolean("UseE", "Use E for KS", true)
Menu:Menu("misc", "Misc")
Menu.misc:Slider("pred", "Q Hit Chance", 3,0,10,1)
Menu.misc:Info("info", "         0 = Low - 10 = High")
Menu.misc:Menu("gap", "Anti-Gapclosers")

OnLoad (function()
  if not igniteFound then
      if GetCastName(myHero, SUMMONER_1):lower():find("summonerdot") then
          igniteFound = true
          summonerSpells.ignite = SUMMONER_1
          Menu.KillSteal:Boolean("ignite", "Auto Ignite", true)
      elseif GetCastName(myHero, SUMMONER_2):lower():find("summonerdot") then
          igniteFound = true
          summonerSpells.ignite = SUMMONER_2
          Menu.KillSteal:Boolean("ignite", "Auto Ignite", true)
      end
  end
end)

OnUpdateBuff (function(unit, buff)
  if not unit or not buff or not buff.Count then 
    return 
  end
  if unit.isMe and buff.Name:lower() == "ryzepassivestack" then
    PassiveBuff = buff.Count
  end
  if unit.isMe and buff.Name:lower() == "ryzepassivecharged" then
    Charged = true
  end
end)

OnRemoveBuff (function(unit, buff)
  if unit and unit.isMe and buff.Name:lower():lower() == "ryzepassivestack" then
    PassiveBuff = 0
  end
  if unit.isMe and buff.Name:lower() == "ryzepassivecharged" then
    Charged = false
  end
end)

OnTick (function()
  if IsDead(myHero) then 
    return 
  end
  if Menu.Combo.c:Value() then
    local qTarget = GetBestTarget(Q.range)
    if qTarget and (GetDistance(qTarget) > 440 or Ready(_E) or Ready(_Q)) and GetCurrentHP(qTarget) > 3*getdmg('AD',qTarget,myHero) then
      BlockF7OrbWalk(true)
      MoveToXYZ(GetMousePos())
    else
      BlockF7OrbWalk(false)
    end
    Combo()
  end
  KillSteal()
end)

function CastQ(unit)
  if unit then
    local pI = GetPrediction(unit, Q)
    if pI and pI.hitChance >= (Menu.misc.pred:Value() * 0.1) and not pI:mCollision(1) then
      CastSkillShot(_Q, pI.castPos)
    end
  end
end

function CastQn(unit)
  if unit then
    local pI = GetPrediction(unit, Q)
    CastSkillShot(_Q, pI.castPos)
  end
end

function KillSteal()
  if not Menu.KillSteal.KS:Value() then 
    return 
  end
  local ks = GetBestTarget(Q.range)
  if ks ~= nil and ValidTarget(ks) then
    if Menu.KillSteal.UseQ:Value() and Ready(_Q) and GetDamage(_Q,ks) > GetCurrentHP(ks) and GetDistance(ks) < Q.range then
      CastQ(ks)
    elseif  Menu.KillSteal.UseW:Value() and Ready(_W) and GetDamage(_W,ks) > GetCurrentHP(ks) and GetDistance(ks) <= W.range then
      CastTargetSpell(ks, _W)
    elseif Menu.KillSteal.UseE:Value() and Ready(_E) and GetDamage(_E,ks) > GetCurrentHP(ks) and GetDistance(ks) <= E.range then
      CastTargetSpell(ks, _E)
    end
  end
end

function Combo()
  local qSpell = Menu.Combo.useQ:Value()
  local eSpell = Menu.Combo.useE:Value()
  local wSpell = Menu.Combo.useW:Value()
  local rSpell = Menu.Combo.useR:Value()
  local rwwSpell = Menu.Combo.useRww:Value()
  local target = GetBestTarget(Q.range)

  if not ValidTarget(target,Q.range) then 
    return 
  end

  if igniteFound and IgniteReady and ValidTarget(target,590) and GetCurrentHP(target) < GetComboDamage({_W,summonerSpells.ignite},target) then
    CastTargetSpell(target, summonerSpells.ignite)
  end
  if GetDistance(target) <= Q.range then
    if GetPassiveBuff() <= 2 and not Ready(_R) then
      if qSpell and Ready(_Q) then
        CastQn(target)
      end
      if ValidTarget(target,W.range) and wSpell and Ready(_W) then
        CastTargetSpell(target, _W)
      end
      if GetDistance(target) <= E.range and eSpell and Ready(_E) then
        CastTargetSpell(target, _E)
      end
    end
    if GetPassiveBuff() <= 2 and Ready(_R) then 
      if qSpell and Ready(_Q) then
        CastQn(target)
      end
      if GetDistance(target) <= E.range and eSpell and Ready(_E) then
        CastTargetSpell(target, _E)
      end
    end
    if GetPassiveBuff() == 3 and not Ready(_R) then
      if ValidTarget(target,W.range) and wSpell and Ready(_W) then
        CastTargetSpell(target, _W)
      end
      if qSpell and Ready(_Q) then
        CastQn(target)
      end
      if GetDistance(target) <= E.range and eSpell and Ready(_E) then
        CastTargetSpell(target, _E)
      end
    end
    if GetPassiveBuff() == 3 and Ready(_R) then
      if Ready(_R) and rSpell then
        if GetDistance(target) <= Q.range and GetCurrentHP(target) > GetDamage(_Q,target) + GetDamage(_E,target) then
          if not rwwSpell or (rwwSpell and GotBuff(target, "RyzeW"))  then
            CastSpell(_R)
          end
        end
      end
    end
    if GetPassiveBuff() == 4 and not Ready(_R) then
      if qSpell and Ready(_Q) then
        CastQn(target)
      end
      if ValidTarget(target,W.range) and wSpell and Ready(_W) then
        CastTargetSpell(target, _W)
      end
      if GetDistance(target) <= E.range and eSpell and Ready(_E) then
        CastTargetSpell(target, _E)
      end
    end
    if GetPassiveBuff() == 4 and Ready(_R) then
      if Ready(_R) and rSpell then
        if GetDistance(target) <= Q.range and GetCurrentHP(target) > GetDamage(_Q,target) + GetDamage(_E,target) then
          if not rwwSpell or (rwwSpell and GotBuff(target, "RyzeW"))  then
            CastSpell(_R)
          end
        end
      end
    end
    if Charged == true and not Ready(_R) then
      if qSpell and Ready(_Q) then
        CastQn(target)
      end

      if ValidTarget(target,W.range) and wSpell and Ready(_W) then
        CastTargetSpell(target, _W)
      end

      if qSpell and Ready(_Q) then
        CastQn(target)
      end

      if GetDistance(target) <= E.range and eSpell and Ready(_E) then
        CastTargetSpell(target, _E)
      end
    end
    if Charged == true and Ready(_R) then
      if Ready(_R) and rSpell then
        if GetDistance(target) <= Q.range and GetCurrentHP(target) > GetDamage(_Q,target) + GetDamage(_E,target) then
          if not rwwSpell or (rwwSpell and GotBuff(target, "RyzeW"))  then
            CastSpell(_R)
          end
        end
      end
    end
  end
end

function GetComboDamage(Combo, Unit)
  local totaldamage = 0
  for i, spell in pairs(Combo) do
    totaldamage = totaldamage + GetDamage(spell, Unit)
  end
  return totaldamage
end

function GetDamage(Spell, Unit)
  local truedamage = 0
  if Spell == _Q and GetCastLevel(GetMyHero(), _Q) ~= 0 then
    truedamage = CalcMagicDamage(GetMyHero(), Unit, Qdamage[GetCastLevel(GetMyHero(), _Q)] + GetBonusAP(GetMyHero()) * 0.55 + Qdamagemana[GetCastLevel(GetMyHero(), _Q)]* GetMaxMana(GetMyHero())/100)
  elseif Spell == _W and GetCastLevel(GetMyHero(), _W) ~= 0  then
    truedamage = CalcMagicDamage(GetMyHero(), Unit, Wdamage[GetCastLevel(GetMyHero(), _W)] + GetBonusAP(GetMyHero()) * 0.4 + GetMaxMana(GetMyHero())*2.5/100)
  elseif Spell == _E and GetCastLevel(GetMyHero(), _E) ~= 0 then
    truedamage = CalcMagicDamage(GetMyHero(), Unit, Edamage[GetCastLevel(GetMyHero(), _E)] + GetBonusAP(GetMyHero()) * 0.3 + GetMaxMana(GetMyHero())*2/100)
  elseif Spell == summonerSpells.ignite and igniteFound and (CanUseSpell(GetMyHero(), summonerSpells.ignite) == READY) then
    truedamage = 50 + 20 * GetLevel(GetMyHero())
  end
  return truedamage
end

function GetBestTarget(Range, Ignore)
  local LessToKill = 100
  local LessToKilli = 0
  local target = nil
  for i, enemy in ipairs(GetEnemyHeroes()) do
    if ValidTarget(enemy, Range) then
      DamageToHero = CalcMagicDamage(GetMyHero(), enemy, 200)
      ToKill = GetCurrentHP(enemy) / DamageToHero
      if ((ToKill < LessToKill) or (LessToKilli == 0)) and (Ignore == nil or (GetNetworkID(Ignore) ~= GetNetworkID(enemy))) then
        LessToKill = ToKill
        LessToKilli = i
        target = enemy
      end
    end
  end
  return target
end

function GetPassiveBuff()
  return PassiveBuff
end

AddGapcloseEvent(_W, 600, true, Menu.misc.gap)
