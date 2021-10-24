-- Stand Power Stone Free
local s, id = GetID()
function s.initial_effect( c )
  -- You can only control 1 "${SP} Stone Free.
  c:SetUniqueOnField(1, 0, id)
  -- Can only be equipped to a "${SU} Cujoh Jolyne" you control.
  aux.AddEquipProcedure(c, 0, aux.FilterBoolFunction(Card.IsCode, 1090076082))
  -- Destroy this instead
  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_EQUIP)
  e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e1:SetCode(EFFECT_DESTROY_REPLACE)
  e1:SetTarget(s.desreptg)
  e1:SetOperation(s.desrepop)
  c:RegisterEffect(e1)
  -- Gains 800 ATK
  local e2 = Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_EQUIP)
  e2:SetCategory(CATEGORY_ATKCHANGE)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetValue(800)
  c:RegisterEffect(e2)
  -- Attack Twice
  local e3 = Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_EQUIP)
  e3:SetCode(EFFECT_EXTRA_ATTACK)
  e3:SetValue(1)
  c:RegisterEffect(e3)
  -- ! removed - no damage
  -- local e4 = Effect.CreateEffect(c)
  -- e4:SetType(EFFECT_TYPE_FIELD)
  -- e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
  -- e4:SetRange(LOCATION_SZONE)
  -- c:RegisterEffect(e4)
  -- direct attack
  local e5 = Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_EQUIP)
  e5:SetCode(EFFECT_DIRECT_ATTACK)
  c:RegisterEffect(e5)
  -- reduce damage
  local e6 = Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
  e6:SetCode(EVENT_BATTLE_START)
  e6:SetRange(LOCATION_SZONE)
  e6:SetCondition(s.rdcon)
  e6:SetOperation(s.rdop)
  c:RegisterEffect(e6)
end

s.listed_names = { 1090076082, 1090076083 }
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

function s.rdcon( e, tp, eg, ep, ev, re, r, rp )
  local c = e:GetHandler():GetEquipTarget()
  return Duel.GetAttackTarget() == nil and Duel.GetAttacker() == c and
           c:IsHasEffect(EFFECT_DIRECT_ATTACK)
end

function s.rdop( e, tp, eg, ep, ev, re, r, rp )
  local c = e:GetHandler()
  local tc = c:GetEquipTarget()
  local effs = { tc:GetCardEffect(EFFECT_DIRECT_ATTACK) }
  local eg = Group.CreateGroup()
  for _, eff in ipairs(effs) do
    eg:AddCard(eff:GetOwner())
  end
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EFFECT)
  local ec = #eg == 1 and eg:GetFirst() or eg:Select(tp, 1, 1, nil):GetFirst()
  if c == ec then
    local e2 = Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(-700)
    e2:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
    tc:RegisterEffect(e2)
  end
end
