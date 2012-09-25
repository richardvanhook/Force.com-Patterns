trigger OpptyTrigger on Opportunity (after insert, after update) {

	if (trigger.isAfter && (trigger.isInsert || trigger.isUpdate)) {
		List<Opportunity> closedOpptyList = new List<Opportunity>();
		for (Opportunity oppty : trigger.new) {
			if (oppty.isClosed && (trigger.isInsert || 
					(trigger.isUpdate && !trigger.oldMap.get(oppty.id).isClosed)))
				closedOpptyList.add(oppty);	
		}
		if (!closedOpptyList.isEmpty()) 
			new OrderClass().CreateOrdersFromOpptys(closedOpptyList);
	}			
}