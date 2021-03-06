--Mantra Wiseman
--Automate ID
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end

local scard,s_id=getID()

function scard.initial_effect(c)
	--Recover
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(scard.con)
	e1:SetTarget(scard.target)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(scard.cost)
	e1:SetCountLimit(1)
	e1:SetOperation(scard.operation)
	c:RegisterEffect(e1)
	if not scard.global_check then
		scard.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(scard.archchk)
		Duel.RegisterEffect(ge2,0)
	end
end
function scard.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,30000)==0 then 
		Duel.CreateToken(tp,30000)
		Duel.CreateToken(1-tp,30000)
		Duel.RegisterFlagEffect(0,30000,0,0,0)
	end
end
function scard.handfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsMantra() and c:IsAbleToHand()
end
function scard.con(e,tp,c,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(scard.handfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function scard.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and scard.handfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(scard.handfilter,tp,LOCATION_GRAVE,nil,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,scard.handfilter,tp,LOCATION_GRAVE,nil,1,1,nil)
	local g1=g:GetFirst()
	if g1 and g1:IsType(TYPE_EFFECT) and g1:GetLevel()<=4 and not g1:IsCode(s_id) and g1:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		e:SetCategory(CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON)
	end
end
function scard.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function scard.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsControler(tp)
		and tc:IsLevelBelow(4) and not tc:IsCode(s_id) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(30212,2))
	then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
end
