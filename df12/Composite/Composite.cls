public abstract class Composite implements Expression{
    public List<Expression> children   {get; private set;} 
    public Composite(){ 
    	this.children = new List<Expression>(); 
    }
    public Expression add(Expression expr){
    	children.add(expr);
    	return this;
    }
    public Expression set(String name, Boolean value){
    	for(Expression expr : children) expr.set(name,value);
        return this;
    }
    public abstract Boolean evaluate();
    public Boolean hasChildren{get{ 
    	return !children.isEmpty(); 
    }}
}