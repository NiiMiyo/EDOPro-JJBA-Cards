-- Stand User Kujo Jotaro
local s, id = GetID()
function s.initial_effect( c )
  local e2 = Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EVENT_BATTLE_DESTROYING)
  e2:SetCondition(s.condition)
  e2:SetOperation(s.operation)
  c:RegisterEffect(e2)
end

function s.condition( e, tp, eg, ep, ev, re, r, rp )
  return e:GetHandler():IsRelateToBattle() and e:GetHandler():IsFaceup()
end

function s.operation( e, tp, eg, ep, ev, re, r, rp )
  local c = e:GetHandler()
  if c:GetBattleTarget() then
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(200)
    e1:SetReset(RESET_EVENT + RESETS_STANDARD_DISABLE)
    c:RegisterEffect(e1)
  end
end
