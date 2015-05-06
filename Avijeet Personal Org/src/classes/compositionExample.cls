public class compositionExample {
    public integer a {get;set;}
    
    public PageReference test() {
        a++;
        return null;
    }
    
    public compositionExample (){
        a=0;
    }

    public String colorField { get; set; }

    public String showGreeting { get; set; }

    public String mealField { get; set; }

    public String ageField { get; set; }

    public String nameField { get; set; }
}