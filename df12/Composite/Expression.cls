public interface Expression {
	Expression add(Expression expr);
	Expression set(String name, Boolean value);
	Boolean evaluate();
}