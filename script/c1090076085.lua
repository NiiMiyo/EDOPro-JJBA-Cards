-- Stand Power Hermit Purple
local s, id = GetID()
function s.initial_effect(c)
  -- You can only control 1 "${SP} Hermit Purple.
  c:SetUniqueOnField(1, 0, id)

  -- Can only be equipped to a "${SU} Joseph Joestar" you control.
  aux.AddEquipProcedure(c, 0, aux.FilterBoolFunction(Card.IsCode, 1090076084))

  -- Destroy this instead
  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_EQUIP)
  e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e1:SetCode(EFFECT_DESTROY_REPLACE)
  e1:SetTarget(s.desreptg)
  e1:SetOperation(s.desrepop)
  c:RegisterEffect(e1)

  -- Gains 300 ATK
  local e2 = Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_EQUIP)
  e2:SetCategory(CATEGORY_ATKCHANGE)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetValue(300)
  c:RegisterEffect(e2)
  -- Gains 600 DEF
  local e2_1 = e2:Clone()
  e2_1:SetCode(EFFECT_UPDATE_DEFENSE)
  e2_1:SetValue(600)
  c:RegisterEffect(e2_1)

  -- rearrange
  local e3 = Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_SZONE)
  e3:SetCountLimit(1)
  e3:SetTarget(s.arrange_target)
  e3:SetOperation(s.arrange_operation)
  c:RegisterEffect(e3)

  -- coin
  local e4 = Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
  e4:SetRange(LOCATION_SZONE)
  e4:SetCode(EVENT_TOSS_COIN_NEGATE)
  e4:SetCondition(s.coincon)
  e4:SetOperation(s.coinop)
  c:RegisterEffect(e4)
end

s.listed_names = {1090076084, 1090076085}
s.toss_coin = true
function s.desreptg(e, tp, eg, ep, ev, re, r, rp, chk)
  local c = e:GetHandler()
  local tg = c:GetEquipTarget()
  if chk == 0 then
    return c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and tg and
      tg:IsReason(REASON_BATTLE + REASON_EFFECT)
  end
  return Duel.SelectEffectYesNo(tp, c, 96)
end
function s.desrepop(e, tp, eg, ep, ev, re, r, rp)
  Duel.Destroy(e:GetHandler(), REASON_EFFECT + REASON_REPLACE)
end

function s.arrange_target(e, tp, eg, ep, ev, re, r, rp, chk)
  if chk == 0 then
    return Duel.GetFieldGroupCount(tp, 0, LOCATION_DECK) > 2
  end
end
function s.arrange_operation(e, tp, eg, ep, ev, re, r, rp)
  if not e:GetHandler():IsRelateToEffect(e) then
    return
  end
  Duel.SortDecktop(tp, 1 - tp, 3)
  aux.RegisterClientHint(e:GetHandler(), nil, tp, 1, 0, aux.Stringid(id, 2), nil)
end

function s.coincon(e, tp, eg, ep, ev, re, r, rp)
  return ep == tp and Duel.GetFlagEffect(tp, id) == 0
end
function s.coinop(e, tp, eg, ep, ev, re, r, rp)
  if Duel.GetFlagEffect(tp, id) ~= 0 then
    return
  end
  if Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
    Duel.Hint(HINT_CARD, 0, id)
    Duel.RegisterFlagEffect(tp, id, RESET_CHAIN, 0, 1)
    Duel.TossCoin(tp, ev)
  end
end
