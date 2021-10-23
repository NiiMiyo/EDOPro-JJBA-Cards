-- Stand Power Crazy Diamond
local s, id = GetID()
function s.initial_effect( c )
  -- You can only control 1 "${SP} Crazy Diamond".
  c:SetUniqueOnField(1, 0, id)
  -- Can only be equipped to a "${SU} Kujo Jotaro" you control.
  aux.AddEquipProcedure(c, 0, aux.FilterBoolFunction(Card.IsCode, 1090076072))
  -- Destroy this instead
  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_EQUIP)
  e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e1:SetCode(EFFECT_DESTROY_REPLACE)
  e1:SetTarget(s.desreptg)
  e1:SetOperation(s.desrepop)
  c:RegisterEffect(e1)
  -- Gains 900 ATK
  local e2 = Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_EQUIP)
  e2:SetCategory(CATEGORY_ATKCHANGE)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetValue(900)
  c:RegisterEffect(e2)
  -- Attack Twice
  local e3 = Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_EQUIP)
  e3:SetCode(EFFECT_EXTRA_ATTACK)
  e3:SetValue(1)
  c:RegisterEffect(e3)
  -- recover lp
  local e4 = Effect.CreateEffect(c)
  e4:SetCategory(CATEGORY_RECOVER)
  e4:SetType(EFFECT_TYPE_IGNITION)
  e4:SetRange(LOCATION_SZONE)
  e4:SetCountLimit(1)
  e4:SetTarget(s.target)
  e4:SetOperation(s.operation)
  c:RegisterEffect(e4)
end

s.listed_names = { 1090076076, 1090076072 }
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

function s.filter( c, e )
  return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsCanBeEffectTarget(e)
end
function s.target( e, tp, eg, ep, ev, re, r, rp, chk )
  local c = e:GetHandler():GetEquipTarget()
  if chk == 0 then
    return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_MZONE, 0, 1, c, e)
  end

  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FACEUP)
  local g = Duel.SelectTarget(tp, s.filter, tp, LOCATION_MZONE, 0, 1, 1, c, e)
  local recover = g:GetFirst():GetAttack() / 2
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(recover)
  Duel.SetOperationInfo(0, CATEGORY_RECOVER, nil, 0, tp, recover)
end
function s.operation( e, tp, eg, ep, ev, re, r, rp )
  if not e:GetHandler():IsRelateToEffect(e) then
    return
  end
  local p, d = Duel.GetChainInfo(
                 0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM
               )
  Duel.Recover(p, d, REASON_EFFECT)
end
function s.granttarget( e, c )
  local q = e:GetHandler():GetEquipTarget()
  local g = Group.CreateGroup()
  g.AddCard(q)
  return g.IsContains(c)
end

function s.eftg( e, c )
  local eqp = e:GetHandler():GetEquipTarget()
  return eqp ~= nil and eqp == c
end
