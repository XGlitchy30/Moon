 --Created and coded by Rising Phoenix
function c100001155.initial_effect(c)
		--act
			local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e10=Effect.CreateEffect(c)
	e10:SetOperation(c100001155.actb)
	e10:SetCost(c100001155.descost)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e10:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e10:SetRange(LOCATION_DECK)
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e10)
	--acthand
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e20:SetRange(LOCATION_HAND)
	e20:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e20:SetOperation(c100001155.actb)
	e20:SetCost(c100001155.descost)
	e20:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e20)
	--actgrave
	local e30=Effect.CreateEffect(c)
	e30:SetOperation(c100001155.actb)
	e30:SetCost(c100001155.descost)
	e30:SetRange(LOCATION_GRAVE)
	e30:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e30:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e30:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e30)
		--actremoved
	local e40=Effect.CreateEffect(c)
	e40:SetOperation(c100001155.actb)
	e40:SetCost(c100001155.descost)
	e40:SetRange(LOCATION_REMOVED)
	e40:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e40:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e40:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e40)
		--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetValue(c100001155.efilter)
	c:RegisterEffect(e4)
		--cannot act
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_ACTIVATE)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetRange(LOCATION_ONFIELD)
	e9:SetTargetRange(1,0)
	e9:SetValue(c100001155.actset)
	c:RegisterEffect(e9)
	--cannot set
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_CANNOT_MSET)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetRange(LOCATION_ONFIELD)
	e10:SetValue(c100001155.actset)
	e10:SetTargetRange(1,0)
	e10:SetTarget(aux.TRUE)
	c:RegisterEffect(e10)
	local e12=e10:Clone()
	e12:SetValue(c100001155.actset)
	e12:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e12)
	local e13=e10:Clone()
	e13:SetValue(c100001155.actset)
	e13:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e13:SetTarget(c100001155.sumlimit)
	c:RegisterEffect(e13)
	--cannot sp
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD)
	e14:SetRange(LOCATION_ONFIELD)
	e14:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e14:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e14:SetTargetRange(1,0)
	e14:SetTarget(c100001155.spslimit)
	c:RegisterEffect(e14)
		--cannot ns
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_FIELD)
	e15:SetRange(LOCATION_ONFIELD)
	e15:SetCode(EFFECT_CANNOT_SUMMON)
	e15:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e15:SetTargetRange(1,0)
	e15:SetTarget(c100001155.spslimit)
	c:RegisterEffect(e15)
end
function c100001155.actset(e,re,tp)
	local rc=re:GetHandler()
	return not rc:IsSetCard(0x11E) and not rc:IsImmuneToEffect(e)
end
function c100001155.spslimit(e,c)
	return not c:IsSetCard(0x11E)
end
function c100001155.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)~=0
end
function c100001155.efun(e,ep,tp)
	return ep==tp
end
function c100001155.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c100001155.actb(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetActivateEffect():IsActivatable(tp) end
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,REASON_EFFECT,true)
end
function c100001155.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,100001155)==0 end
	Duel.RegisterFlagEffect(tp,100001155,0,0,0)
end
