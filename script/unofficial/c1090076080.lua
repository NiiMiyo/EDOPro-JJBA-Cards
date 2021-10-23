-- Stand Power Gold Experience
local s, id = GetID()
function s.initial_effect( c )
  -- You can only control 1 "${SP} Gold Experience.
  c:SetUniqueOnField(1, 0, id)
  -- Can only be equipped to a "${SU} Giorno Giovanna" you control.
  aux.AddEquipProcedure(c, 0, aux.FilterBoolFunction(Card.IsCode, 1090076079))
  -- Destroy this instead
  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_EQUIP)
  e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e1:SetCode(EFFECT_DESTROY_REPLACE)
  e1:SetTarget(s.desreptg)
  e1:SetOperation(s.desrepop)
  c:RegisterEffect(e1)
  -- Gains 500 ATK/DEF
  local e2 = Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_EQUIP)
  e2:SetCategory(CATEGORY_ATKCHANGE)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetValue(500)
  c:RegisterEffect(e2)
  local e2_1 = e2:Clone()
  e2_1:SetCode(EFFECT_UPDATE_DEFENSE)
  e2_1:SetValue(800)
  c:RegisterEffect(e2_1)
  -- Attack Twice
  local e3 = Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_EQUIP)
  e3:SetCode(EFFECT_EXTRA_ATTACK)
  e3:SetValue(1)
  c:RegisterEffect(e3)
  -- pierce
  local e4 = Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_EQUIP)
  e4:SetCode(EFFECT_PIERCE)
  e4:SetValue(1)
  c:RegisterEffect(e4)
  -- special summon from gy
  local e5 = Effect.CreateEffect(c)
  e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetRange(LOCATION_SZONE)
  e5:SetCountLimit(1)
  e5:SetTarget(s.target)
  e5:SetOperation(s.operation)
  c:RegisterEffect(e5)
end

s.listed_names = { 1090076080, 1090076079 }
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

function s.filter( c, e, tp )
  return c:IsCanBeSpecialSummoned(
           e, SUMMON_TYPE_SPECIAL, tp, false, false, POS_FACEUP
         )
end
function s.target( e, tp, eg, ep, ev, re, r, rp, chk, chkc )
  if chkc then
    return chkc:IsLocation(LOCATION_GRAVE) and s.filter(chkc, e, tp)
  end
  if chk == 0 then
    return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and
             Duel.IsExistingTarget(
               s.filter, tp, LOCATION_GRAVE, 0, 1, nil, e, tp
             )
  end
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
  local g = Duel.SelectTarget(
              tp, s.filter, tp, LOCATION_GRAVE, 0, 1, 1, nil, e, tp
            )
  Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, g, 1, 0, 0)
end
function s.operation( e, tp, eg, ep, ev, re, r, rp )
  local tc = Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and
    Duel.SpecialSummon(tc, SUMMON_TYPE_SPECIAL, tp, tp, false, false, POS_FACEUP) then
    local e1 = Effect.CreateEffect(tc)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT + RESETS_REDIRECT)
    e1:SetValue(LOCATION_REMOVED)
    tc:RegisterEffect(e1, true)
  end
end
