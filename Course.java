package course;

public class Course {

    private int     id;
    private String  name;
    private String  instructor;
    private int     totalSelected;   // kaç öğrenci seçti?
    private boolean selectedByUser;  // oturum açan kullanıcı bu dersi seçmiş mi?

    public Course(int id, String name, String instructor,
                  int totalSelected, boolean selectedByUser) {
        this.id             = id;
        this.name           = name;
        this.instructor     = instructor;
        this.totalSelected  = totalSelected;
        this.selectedByUser = selectedByUser;
    }

    /* ----- Getter'lar ----- */
    public int     getId()           { return id; }
    public String  getName()         { return name; }
    public String  getInstructor()   { return instructor; }
    public int     getTotalSelected(){ return totalSelected; }
    public boolean isSelectedByUser(){ return selectedByUser; }
}
