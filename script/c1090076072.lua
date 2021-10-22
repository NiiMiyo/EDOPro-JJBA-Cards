-- Stand User Higashikata Josuke
local s, id = GetID()
function s.initial_effect( c )
  -- effects
  local e1 = Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_BATTLE_START)
  e1:SetCondition(s.atkcon)
  e1:SetOperation(s.atkop)
  c:RegisterEffect(e1)
end

function s.atkcon( e, tp, eg, ep, ev, re, r, rp )
  local c = e:GetHandler()
  local at = Duel.GetAttackTarget()
  return c:IsRelateToBattle() and at:IsRelateToBattle() and
           at:IsRace(RACE_REPTILE)
end

function s.atkop( e, tp, eg, ep, ev, re, r, rp )
  if not e:GetHandler():IsRelateToEffect(e) then
    return
  end
  local at = Duel.GetAttacker()
  if at:IsFaceup() and at:IsRelateToBattle() then
    local e2 = Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(-200)
    e2:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_BATTLE)
    at:RegisterEffect(e2)
  end
end
