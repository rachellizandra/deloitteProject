public class RelatorioVisitasCTRL {
	public Account conta {get;set;}
    public String recordId {get;set;}
    
    public RelatorioVisitasCTRL(ApexPages.StandardController controller){
        this.recordId = (String) controller.getId();
    }
}