-- Stand Power Star Platinum
local s, id = GetID()
function s.initial_effect( c )
  -- You can only control 1 "${SP} Star Platinum".
  c:SetUniqueOnField(1, 0, id)
  -- Can only be equipped to a "${SU} Kujo Jotaro" you control.
  aux.AddEquipProcedure(c, 0, aux.FilterBoolFunction(Card.IsCode, 1090076074))
  -- Destroy this instead
  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_EQUIP)
  e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e1:SetCode(EFFECT_DESTROY_REPLACE)
  e1:SetTarget(s.desreptg)
  e1:SetOperation(s.desrepop)
  c:RegisterEffect(e1)
  -- Gains 1000 ATK
  local e2 = Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_EQUIP)
  e2:SetCategory(CATEGORY_ATKCHANGE)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetValue(1000)
  c:RegisterEffect(e2)
  -- Attack Twice
  local e3 = Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_EQUIP)
  e3:SetCode(EFFECT_EXTRA_ATTACK)
  e3:SetValue(1)
  c:RegisterEffect(e3)
  -- battle resist
  local e4 = Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_EQUIP)
  e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e4:SetValue(1)
  c:RegisterEffect(e4)
end

s.listed_names = { 2233678692, 1090076074 }
function s.desreptg( e, tp, eg, ep, ev, re, r, rp, chk )
  local c = e:GetHandler()
  local tg = c:GetEquipTarget()
  if chk == 0 then
    return c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and
             tg and tg:IsReason(REASON_BATTLE + REASON_EFFECT)
  end
  return Duel.SelectEffectYesNo(tp, c, 96)
end
function s.desrepop( e, tp, eg, ep, ev, re, r, rp )
  Duel.Destroy(e:GetHandler(), REASON_EFFECT + REASON_REPLACE)
end
