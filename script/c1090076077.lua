-- Meteorite Arrow
local s, id = GetID()
function s.initial_effect( c )
  --     -- activate
  local e1 = Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetTarget(s.target)
  e1:SetOperation(s.activate)
  e1:SetCountLimit(1, id)
  c:RegisterEffect(e1)
end

s.listed_names = { 1090076077 }
s.listed_series = { 0xf00, 0xf01 }
function s.targetfilter( chkc, e, tp )
  return chkc:IsSetCard(0xf00)
end

function s.spfilter( c, class, e, tp )
  if c == nil or c.listed_names == nil then
    return false
  end

  local code = class:GetCode()
  for i = 1, #c.listed_names do
    if code == c.listed_names[i] then
      return c:IsAbleToHand()
    end
  end
  return false
end

function s.sufilter( c, e, tp )
  if c:IsSetCard(0xf00) and c:IsFaceup() and c:IsType(TYPE_MONSTER) then
    return Duel.IsExistingMatchingCard(
             s.spfilter, tp, LOCATION_DECK, 0, 1, nil, c, e, tp
           )
  end
  return false
end

function s.target( e, tp, eg, ep, ev, re, r, rp, chk, chkc )
  if chk == 0 then
    return Duel.IsExistingMatchingCard(
             s.sufilter, tp, LOCATION_MZONE, 0, 1, nil, e, tp
           )
  end
  local g = Duel.SelectTarget(
              tp, s.sufilter, tp, LOCATION_MZONE, 0, 1, 1, nil, e, tp
            )
  Duel.SetOperationInfo(0, CATEGORY_TOHAND, g, 1, tp, LOCATION_DECK)
end

function s.activate( e, tp, eg, ep, ev, re, r, rp )
  local class = Duel.GetTargetCards(e):GetFirst()
  if class == nil then
    return
  end
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
  local g = Duel.SelectMatchingCard(
              tp, s.spfilter, tp, LOCATION_DECK, 0, 1, 1, nil, class, e, tp
            )
  local tc = g:GetFirst()
  if tc then
    Duel.SendtoHand(tc, tp, REASON_EFFECT)
  end
end
