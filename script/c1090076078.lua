-- Do You Believe in Gravity?
local s, id = GetID()
function s.initial_effect( c )
  -- search
  local e1 = Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TOHAND)
  e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_PHASE + PHASE_STANDBY)
  e1:SetRange(LOCATION_SZONE)
  e1:SetCountLimit(1, id)
  e1:SetCondition(s.searchcon)
  e1:SetOperation(s.searchop)
  c:RegisterEffect(e1)
  -- activate
  local e2 = Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_ACTIVATE)
  e2:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e2)
end

s.listed_series = { 0xf00 }
s.listed_names = { 1090076077 }
function s.searchfilter( c, e, tp )
  return (c:IsSetCard(0xf00) and c:IsType(TYPE_MONSTER)) or
           (c:IsCode(1090076077))
end

function s.fieldsearchfilter( c, e, tp )
  return c:IsSetCard(0xf00) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and
           c:IsControler(tp)
end

function s.searchcon( e, tp, eg, ep, ev, re, r, rp )
  return Duel.GetTurnPlayer() == tp and Duel.IsExistingMatchingCard(
           s.fieldsearchfilter, tp, LOCATION_MZONE, 0, 1, nil, e, tp
         ) and
           Duel.IsExistingMatchingCard(
             s.searchfilter, tp, LOCATION_DECK, 0, 1, nil, e, tp
           )
end

function s.searchop( e, tp, eg, ep, ev, re, r, rp, chk, chkc )
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
  local g = Duel.SelectMatchingCard(
              tp, s.searchfilter, tp, LOCATION_DECK, 0, 1, 1, nil, e, tp
            )
  local tc = g:GetFirst()
  if tc then
    Duel.SendtoHand(tc, tp, REASON_EFFECT)
  end

end
