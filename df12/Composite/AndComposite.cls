public class AndComposite extends Composite{
    public override Boolean evaluate(){
        for(Expression expr : children) if(!expr.evaluate()) return false;
        return true;
    }
}