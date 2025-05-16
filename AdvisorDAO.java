package advisor;

import java.sql.*;
import java.util.*;

public class AdvisorDAO {

    private static final String JDBC_URL  = "jdbc:mysql://localhost:3306/upload";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASS = "";

    static {
        try { Class.forName("com.mysql.cj.jdbc.Driver"); }
        catch (ClassNotFoundException e) { e.printStackTrace(); }
    }

    /* ========== 1) Tüm danışmanlar ========= */
    public List<Advisor> getAllAdvisors() {
        List<Advisor> list = new ArrayList<>();
        String sql = "SELECT id, name FROM advisor ORDER BY id";
        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql);
             ResultSet r = s.executeQuery()) {
            while (r.next())
                list.add(new Advisor(r.getInt("id"), r.getString("name")));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /* ========== 2) Öğrenciye danışman ata ========= */
    public boolean selectAdvisor(String user, int advisorId) {
        String sql = "INSERT IGNORE INTO user_advisor (userName, advisorId) VALUES (?,?)";
        try (Connection c = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement s = c.prepareStatement(sql)) {
            s.setString(1, user);
            s.setInt(2, advisorId);
            return s.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    /* ========== 3)  Admin – tüm seçimler ========= */
    public static class AdvisorSelection {
        public final String userName, advisorName;
        public AdvisorSelection(String u,String a){ userName=u; advisorName=a; }
        public String getUserName()    { return userName; }
        public String getAdvisorName() { return advisorName; }
    }
    public List<AdvisorSelection> getAllSelections(){
        List<AdvisorSelection> l=new ArrayList<>();
        String sql="SELECT ua.userName,a.name FROM user_advisor ua JOIN advisor a ON a.id=ua.advisorId";
        try(Connection c=DriverManager.getConnection(JDBC_URL,JDBC_USER,JDBC_PASS);
            PreparedStatement s=c.prepareStatement(sql);
            ResultSet r=s.executeQuery()){
            while(r.next()) l.add(new AdvisorSelection(r.getString(1),r.getString(2)));
        }catch(SQLException e){e.printStackTrace();}
        return l;
    }

    /* ========== 4)  Öğrencinin danışmanı var mı?  ========= */   // ← YENİ
    public boolean hasAdvisor(String user){
        String sql="SELECT 1 FROM user_advisor WHERE userName=? LIMIT 1";
        try(Connection c=DriverManager.getConnection(JDBC_URL,JDBC_USER,JDBC_PASS);
            PreparedStatement s=c.prepareStatement(sql)){
            s.setString(1,user);
            try(ResultSet r=s.executeQuery()){ return r.next(); }
        }catch(SQLException e){ e.printStackTrace(); }
        return false;
    }
    
    /* ... mevcut kod ... */

/** Yöneticinin seçimi tamamen silmesine yarar */
public void deleteSelection(String userName){
    String sql="DELETE FROM user_advisor WHERE userName=?";
    try(Connection c=DriverManager.getConnection(JDBC_URL,JDBC_USER,JDBC_PASS);
        PreparedStatement s=c.prepareStatement(sql)){
        s.setString(1,userName);
        s.executeUpdate();
    }catch(SQLException e){e.printStackTrace();}
}

/*  AdvisorDAO.java  ------------------------------------------ */
public void clearAdvisor(String user) {
    String sql = "DELETE FROM user_advisor WHERE userName=?";
    try (Connection c = DriverManager.getConnection(JDBC_URL,JDBC_USER,JDBC_PASS);
         PreparedStatement s = c.prepareStatement(sql)) {
        s.setString(1, user);
        s.executeUpdate();
    } catch (SQLException e) { e.printStackTrace(); }
}

 /* ========== KULLANICI DANIŞMAN SEÇMİŞ Mİ? ========== */
public boolean hasSelectedAdvisor(String user){
    String sql="SELECT 1 FROM user_advisor WHERE userName=? LIMIT 1";
    try(Connection c=DriverManager.getConnection(JDBC_URL,JDBC_USER,JDBC_PASS);
        PreparedStatement s=c.prepareStatement(sql)){
        s.setString(1,user);
        try(ResultSet r=s.executeQuery()){ return r.next(); }
    }catch(SQLException e){ e.printStackTrace(); }
    return false;
}
/*  KULLANICININ ONAY BEKLEYEN DANIŞMANI VAR MI?  */
public boolean hasPendingAdvisor(String userName){
    String sql = "SELECT 1 FROM user_advisor "
               + "WHERE userName=? AND COALESCE(approved,0)=0 LIMIT 1";
    try(Connection c = DriverManager.getConnection(JDBC_URL,JDBC_USER,JDBC_PASS);
        PreparedStatement ps = c.prepareStatement(sql)){
        ps.setString(1,userName);
        try(ResultSet r = ps.executeQuery()){ return r.next(); }
    }catch(SQLException e){ e.printStackTrace(); }
    return false;
}
/*  KULLANICININ ONAYLANMIŞ DANIŞMAN ID’LERİ  */
public List<Integer> getApprovedAdvisorIds(String userName){
    List<Integer> list = new ArrayList<>();
    String sql = "SELECT advisorId FROM user_advisor "
               + "WHERE userName=? AND approved=1";
    try(Connection c = DriverManager.getConnection(JDBC_URL,JDBC_USER,JDBC_PASS);
        PreparedStatement ps = c.prepareStatement(sql)){
        ps.setString(1,userName);
        try(ResultSet r = ps.executeQuery()){
            while(r.next()) list.add(r.getInt(1));
        }
    }catch(SQLException e){ e.printStackTrace(); }
    return list;
}

}
