-- Stand User Giorno Giovanna
local s, id = GetID()
function s.initial_effect( c )
  -- Target 1 "Meteorite Arrow" in your GY; add it to your hand.
  local e1 = Effect.CreateEffect(c)
  e1:SetCode(EVENT_ATTACK_ANNOUNCE)
  e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1, id)
  e1:SetCondition(s.condition)
  e1:SetTarget(s.target)
  e1:SetOperation(s.operation)
  c:RegisterEffect(e1)
end

s.listed_names = { 1090076077 }
function s.filter( c )
  return c:IsCode(1090076077) and c:IsAbleToHand()
end

function s.condition( e, tp, eg, ep, ev, re, r, rp )
  return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_GRAVE, 0, 1, nil)
end
function s.target( e, tp, eg, ep, ev, re, r, rp, chk )
  if chk == 0 then
    return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_GRAVE, 0, 1, nil)
  end
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
  local g = Duel.SelectTarget(tp, s.filter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
  Duel.SetOperationInfo(0, CATEGORY_TOHAND, g, 1, tp, LOCATION_GRAVE)
end
function s.operation( e, tp, eg, ep, ev, re, r, rp )
  local class = Duel.GetTargetCards(e):GetFirst()
  if class == nil then
    return
  end
  Duel.SendtoHand(class, tp, REASON_EFFECT)

  local ge1 = Effect.CreateEffect(e:GetHandler())
  ge1:SetType(EFFECT_TYPE_FIELD)
  ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  ge1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
  ge1:SetTargetRange(1, 0)
  ge1:SetTarget(s.splimit)
  ge1:SetReset(RESET_PHASE + PHASE_END)
  Duel.RegisterEffect(ge1, tp)
end

function s.splimit(e, c, sump, sumtype, sumpos, targetp, se)
  return c:IsLocation(LOCATION_EXTRA)
end