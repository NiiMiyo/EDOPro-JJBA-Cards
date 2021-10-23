-- Jonathan Joestar
local s, id = GetID()
function s.initial_effect( c )
  -- effects
  -- Unaffected by the effect of Zombie monsters.
  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_IMMUNE_EFFECT)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetValue(s.immunity_filter)
  c:RegisterEffect(e1)

  -- Before damage calculation, if this card battles a Zombie monster while in face-up attack position:
  -- You can destroy that monster, and if you do, your oponent takes damage equals half that monster's ATK.
  local e2 = Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_DESTROY)
  e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_BATTLE_START)
  e2:SetCondition(s.descon)
  e2:SetTarget(s.destg)
  e2:SetOperation(s.desop)
  c:RegisterEffect(e2)
end

function s.immunity_filter( e, te )
  return te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsRace(RACE_ZOMBIE)
end

function s.descon( e )
  local c = e:GetHandler()
  return c:IsFaceup() and c:IsAttackPos()
end

function s.destg( e, tp, eg, ep, ev, re, r, rp, chk )
  local c = e:GetHandler()
  local bc = c:GetBattleTarget()
  if chk == 0 then
    return bc and bc:IsRace(RACE_ZOMBIE)
  end
  Duel.SetOperationInfo(0, CATEGORY_DESTROY, bc, 1, 0, 0)
end

function s.desop( e, tp, eg, ep, ev, re, r, rp )
  local c = e:GetHandler()
  local bc = c:GetBattleTarget()
  if bc:IsRelateToBattle() then
    if Duel.Destroy(bc, REASON_EFFECT) ~= 0 then
      Duel.Damage(tp + 1, bc:Attack() / 2, REASON_EFFECT)
    end
  end
end
