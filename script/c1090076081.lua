-- Stand Power Gold Experience Requiem
local s, id = GetID()
function s.initial_effect( c )
  c:EnableReviveLimit()
  -- You can only control 1 "${SP| Gold Experience Requiem}"
  c:SetUniqueOnField(1, 0, id)

  --  Must first be Special Summoned from your extra deck by tributing
  -- 1 "${SU| Giorno Giovanna}" you control who has a "${SP| Gold Experience}" equipped to it
  -- and banishing 1 "Meteorite Arrow" from your hand or graveyard
  local e2 = Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_IGNITION)
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_RELEASE)
  e2:SetProperty(
    EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE +
      EFFECT_FLAG_CANNOT_NEGATE + EFFECT_FLAG_CANNOT_NEGATE
  )
  e2:SetRange(LOCATION_EXTRA)
  e2:SetCondition(s.spcon)
  e2:SetCost(s.spcost)
  e2:SetTarget(s.sptg)
  e2:SetOperation(s.spop)
  c:RegisterEffect(e2)

  -- ! OK - Unaffected by all effects.
  local e3 = Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_IMMUNE_EFFECT)
  e3:SetProperty(
    EFFECT_FLAG_SINGLE_RANGE + EFFECT_FLAG_CANNOT_DISABLE +
      EFFECT_FLAG_CANNOT_NEGATE
  )
  e3:SetRange(LOCATION_MZONE)
  e3:SetValue(s.efilter)
  c:RegisterEffect(e3)

  -- ! OK -- Cannot be targeted by battle.
  -- local e4 = Effect.CreateEffect(c)
  -- e4:SetType(EFFECT_TYPE_SINGLE)
  -- e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
  -- e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE + EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE +
  --                    EFFECT_FLAG_CANNOT_NEGATE + EFFECT_FLAG_CANNOT_NEGATE)
  -- e4:SetValue(1)
  -- c:RegisterEffect(e4)

  -- ! OK Cannot be targeted by your opponent card effects.
  local e5 = Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_SINGLE)
  e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e5:SetProperty(
    EFFECT_FLAG_SINGLE_RANGE + EFFECT_FLAG_CANNOT_DISABLE +
      EFFECT_FLAG_UNCOPYABLE + EFFECT_FLAG_CANNOT_NEGATE +
      EFFECT_FLAG_CANNOT_NEGATE
  )
  e5:SetRange(LOCATION_MZONE)
  e5:SetValue(aux.tgoval)
  c:RegisterEffect(e5)

  -- ! OK - Cannot be destroyed by battle or card effect.
  local e6 = Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_SINGLE)
  e6:SetProperty(
    EFFECT_FLAG_SINGLE_RANGE + EFFECT_FLAG_CANNOT_DISABLE +
      EFFECT_FLAG_CANNOT_NEGATE
  )
  e6:SetRange(LOCATION_MZONE)
  e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e6:SetValue(1)
  c:RegisterEffect(e6)
  local e6_2 = e6:Clone()
  e6_2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  c:RegisterEffect(e6_2)

  -- ! cannot test - Cannot be used as cost
  local e7 = Effect.CreateEffect(c)
  e7:SetCode(EFFECT_CANNOT_USE_AS_COST)
  e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_CANNOT_NEGATE)
  c:RegisterEffect(e7)

  -- ! OK - At the start of the ${DS}, if this card battles a monster:
  -- Negate the attack, and if you do, banish that monster, and if you do,
  -- your opponent takes damage equals that monster's original ATK.
  local e8 = Effect.CreateEffect(c)
  e8:SetCategory(CATEGORY_DESTROY)
  e8:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
  e8:SetCode(EVENT_BATTLE_START)
  -- e8:SetCondition(s.bancon)
  e8:SetTarget(s.bantg)
  e8:SetOperation(s.banop)
  c:RegisterEffect(e8)

  -- Instant win
  local e9 = Effect.CreateEffect(c)
  e9:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
  e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_CANNOT_NEGATE)
  e9:SetCode(EVENT_DAMAGE_STEP_END)
  e9:SetRange(LOCATION_MZONE)
  e9:SetCondition(s.wincon)
  e9:SetOperation(s.winop)
  c:RegisterEffect(e9)
end

s.listed_names = { 1090076081, 1090076080, 1090076079, 1090076077 }
function s.goldexperiencefilter( c )
  return c:IsCode(1090076080)
end
function s.giornofilter( c, tp )
  if not c:IsCode(1090076079) or not c:IsControler(tp) then
    return false
  end

  local g = c:GetEquipGroup()
  return g ~= nil and g:FilterCount(s.goldexperiencefilter, nil) > 0
end
function s.arrowfilter( c )
  return c:IsCode(1090076077) and c:IsLocation(LOCATION_HAND) and
           c:IsAbleToRemoveAsCost()
end
function s.spcon( e, tp, eg, ep, ev, re, r, rp )
  return Duel.IsExistingMatchingCard(
           s.giornofilter, tp, LOCATION_MZONE, 0, 1, nil, tp
         ) and
           Duel.IsExistingMatchingCard(
             s.arrowfilter, tp, LOCATION_HAND, 0, 1, nil
           )
end
function s.spcost( e, tp, eg, ep, ev, re, r, rp, chk )
  local c = e:GetHandler()
  if chk == 0 then
    return Duel.IsExistingMatchingCard(
             s.giornofilter, tp, LOCATION_MZONE, 0, 1, nil, tp
           ) and
             Duel.IsExistingMatchingCard(
               s.arrowfilter, tp, LOCATION_HAND, 0, 1, nil
             )
  end

  local giornog = Duel.GetMatchingGroup(
                    s.giornofilter, tp, LOCATION_MZONE, 0, nil, tp
                  )
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TRIBUTE)
  local giorno = Duel.SelectTribute(tp, c, 1, 1, giornog)

  local arrowg = Duel.GetMatchingGroup(s.arrowfilter, tp, LOCATION_HAND, 0, nil)
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
  local arrow = Duel.SelectMatchingCard(
                  tp, s.arrowfilter, tp, LOCATION_HAND, 0, 1, 1, nil
                )

  Duel.Remove(arrow, POS_FACEUP, REASON_COST)
  Duel.SendtoGrave(giorno, REASON_COST)
end
function s.sptg( e, tp, eg, ep, ev, re, r, rp, chk )
  if chk == 0 then
    return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and
             e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, true, true)
  end
  Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
end
function s.spop( e, tp, eg, ep, ev, re, r, rp )
  local c = e:GetHandler()
  if not c:IsRelateToEffect(e) then
    return
  end
  if Duel.SpecialSummon(c, 0, tp, tp, true, true, POS_FACEUP) ~= 0 then
    c:CompleteProcedure()
  end
end
function s.efilter( e, te )
  return te:GetOwner() ~= e:GetOwner()
end

function s.bantg( e, tp, eg, ep, ev, re, r, rp, chk )
  local c = e:GetHandler()
  local bc = c:GetBattleTarget()
  if chk == 0 then
    return bc and true
  end
  Duel.SetOperationInfo(0, CATEGORY_REMOVE, bc, 1, 0, 0)
end

function s.banop( e, tp, eg, ep, ev, re, r, rp )
  local c = e:GetHandler()
  local bc = c:GetBattleTarget()
  if bc:IsRelateToBattle() then
    Duel.Remove(bc, nil, REASON_EFFECT)
  end
end

function s.wincon( e, tp, eg, ep, ev, re, r, rp )
  local c = e:GetOwner()
  return Duel.GetAttacker() == c and Duel.GetAttackTarget() == nil
end
function s.winop( e, tp, eg, ep, ev, re, r, rp )
  local c = e:GetHandler()
  local tp = c:GetControler()
  Duel.Win(tp, REASON_EFFECT)
end
