-- 救いの架け橋
-- Bridge of Salvation
-- Scripted by Hatter
local s,id=GetID()
function s.initial_effect(c)
	-- Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(s.tdcon)
	e1:SetTarget(s.tdtg)
	e1:SetOperation(s.tdop)
	c:RegisterEffect(e1)
	-- Search 1 "Crystal Beast" and 1 Field Spell
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,{id,1},EFFECT_COUNT_CODE_DUEL)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
s.listed_series={0x1034}
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.FilterFaceupFunction(Card.IsLevelAbove,10),tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	return #g>1 and g:GetClassCount(Card.GetCode)>1
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,loc,loc,nil,e:GetHandler())
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,5)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,loc,loc,nil,e:GetHandler())
	if #g>0 and Duel.SendtoDeck(g,nil,0,REASON_EFFECT)>0 then
		local dg=Duel.GetOperatedGroup()
		local ct=dg:FilterCount(Card.IsControler,nil,tp)
		if ct>0 then Duel.ShuffleDeck(tp) end
		if #dg>ct then Duel.ShuffleDeck(1-tp) end
		Duel.BreakEffect()
		Duel.Draw(tp,5,REASON_EFFECT)
		Duel.Draw(1-tp,5,REASON_EFFECT)
	end
end
function s.fsfilter(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function s.cbfilter(c,tp)
	return c:IsMonster() and c:IsSetCard(0x1034) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(s.fsfilter,tp,LOCATION_DECK,0,1,c)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cbfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.cbfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	g=g+Duel.SelectMatchingCard(tp,s.fsfilter,tp,LOCATION_DECK,0,1,1,g)
	if #g<2 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end