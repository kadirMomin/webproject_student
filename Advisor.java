package advisor;

public class Advisor {

    private int    id;
    private String name;

    public Advisor(int id, String name) {
        this.id   = id;
        this.name = name;
    }

    public int    getId()   { return id; }
    public String getName() { return name; }
}
