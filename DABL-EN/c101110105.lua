--Japanese name
--Guoglim, Spear of the Ghoti
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	--Synchro Summon Procedure
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_FISH),1,1,Synchro.NonTuner(nil),1,99)
	--Banish battling monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.rmvtg)
	e1:SetOperation(s.rmvop)
	c:RegisterEffect(e1)
	--Banish itself and Special Summon materials
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(function(_,tp) return Duel.IsTurnPlayer(1-tp) end)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
local REASON_SYNCHRO_MATERIAL=REASON_MATERIAL+REASON_SYNCHRO
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetBattleTarget()
	if chk==0 then return tc and tc:IsControler(1-tp) and tc:IsAbleToRemove(tp,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc and tc:IsRelateToBattle() then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.mgfilter(c,e,tp,sync)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and (c:GetReason()&(REASON_SYNCHRO_MATERIAL))==(REASON_SYNCHRO_MATERIAL)
		and c:GetReasonCard()==sync and c:IsType(TYPE_SYNCHRO)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		--Register the properties before banishing itself
		local mg=c:GetMaterial()
		local ct=#mg
		local sumtype=c:GetSummonType()
		if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)>0
			and sumtype==SUMMON_TYPE_SYNCHRO
			and ct>0 and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
			and ct<=Duel.GetLocationCount(tp,LOCATION_MZONE)
			and mg:FilterCount(aux.NecroValleyFilter(s.mgfilter),nil,e,tp,c)==ct
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			if Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)>0 then
				for tc in mg:Iter() do
					--Banish them when it leaves the field
					local e1=Effect.CreateEffect(c)
					e1:SetDescription(3300)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CLIENT_HINT)
					e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
					e1:SetValue(LOCATION_REMOVED)
					tc:RegisterEffect(e1,true)
				end
			end
		end
	end
end