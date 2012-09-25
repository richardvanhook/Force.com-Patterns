public class OrComposite extends Composite{
    public override Boolean evaluate(){
        for(Expression expr : children)if(expr.evaluate()) return true;
        return false;
    }
}