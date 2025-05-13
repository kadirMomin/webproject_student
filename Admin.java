package admin;

public class Admin {

    private int    id;
    private String fullName;
    private String email;
    private String password;

    public Admin(int id, String fullName, String email, String password) {
        this.id        = id;
        this.fullName  = fullName;
        this.email     = email;
        this.password  = password;
    }
    /*  Kayıt eklerken id bilmediğimiz için ikinci ctor */
    public Admin(String fullName, String email, String password) {
        this(0, fullName, email, password);
    }

    /* ----- Getter'lar / Setter'lar ----- */
    public int    getId()       { return id; }
    public String getFullName() { return fullName; }
    public String getEmail()    { return email; }
    public String getPassword() { return password; }

    public void setId(int id) { this.id = id; }
}
