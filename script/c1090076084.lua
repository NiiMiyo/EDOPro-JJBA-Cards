-- Stand User Joseph Joestar
local s, id = GetID()
function s.initial_effect( c )
  -- coin
  local e1 = Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id, 0))
  e1:SetCategory(CATEGORY_HANDES + CATEGORY_COIN)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1, id)
  e1:SetCondition(s.discon)
  e1:SetOperation(s.disop)
  c:RegisterEffect(e1)

  -- change
  local e2 = Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id, 1))
  e2:SetCategory(CATEGORY_POSITION)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetOperation(s.changepos)
  c:RegisterEffect(e2)
end

function s.discon( e, tp, eg, ep, ev, re, r, rp, chk )
  return Duel.IsExistingMatchingCard(
           Card.IsAbleToGrave, tp, 0, LOCATION_HAND, 1, nil
         )
end

function s.disop( e, tp, eg, ep, ev, re, r, rp )
  local coin = Duel.SelectOption(tp, SELECT_HEADS, SELECT_TAILS)
  local res = Duel.TossCoin(tp, 1)
  local con = Duel.IsExistingMatchingCard(
                Card.IsAbleToGrave, tp, 0, LOCATION_HAND, 1, nil
              )
  if con and res ~= coin then
    local g = Duel.GetFieldGroup(tp, 0, LOCATION_HAND)
    local sg = g:Select(tp, 1, 1, false, nil)
    Duel.SendtoGrave(sg, REASON_EFFECT + REASON_DISCARD)
    Duel.ShuffleHand(1 - tp)
  end
end

function s.changepos( e, tp, eg, ep, ev, re, r, rp )
  local c = e:GetHandler()
  Duel.ChangePosition(c, POS_FACEUP_DEFENSE, 0, POS_FACEUP_ATTACK)
end
