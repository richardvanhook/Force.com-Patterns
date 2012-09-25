public with sharing class OrderClass {

	public void CreateOrdersFromOpptys(List<Opportunity> opptyList) {
		List<Order__c> orderList = new List<Order__c>();
		for (Opportunity oppty : opptyList) {
			Order__c order = new Order__c();
			order.name = 'Order for Opportunity ' + oppty.name;
			order.opportunity__c = oppty.id;
			orderList.add(order);
		}
		insert orderList ;
	}

}