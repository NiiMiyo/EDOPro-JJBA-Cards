-- Stand User Cujoh Jolyne
local s, id = GetID()
function s.initial_effect( c )
  -- Negate attack
  local e1 = Effect.CreateEffect(c)
  e1:SetCode(EVENT_ATTACK_ANNOUNCE)
  e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1, id)
  e1:SetCondition(s.condition)
  e1:SetOperation(s.operation)
  c:RegisterEffect(e1)
end

function s.condition( e, tp, eg, ep, ev, re, r, rp )
  local c = e:GetHandler()
  return Duel.GetAttackTarget() == c and c:IsFaceup()
end

function s.operation( e, tp, eg, ep, ev, re, r, rp )
  if not e:GetHandler():IsRelateToEffect(e) then
    return
  end
  Duel.NegateAttack()
end
