package project;

import java.sql.Date;

public class Project {

    /* ---------- Alanlar ---------- */
    private int    id;                 // ← benzersiz anahtar
    private String projectTopic;
    private Date   uploadStartDate;
    private Date   uploadEndDate;
    private String courseName;
    private String advisorName;
    private String githubLink;
    private String libraryLink;
    private String projectDescription;
    private String projectImage;
    private String projectPublished;
    private String publishLink;
    private String projectAwards;

    /* ---------- Kurucular ---------- */

    /* Parametresiz: (framework / JSP ihtiyaçları için) */
    public Project() {}

    /* Tam kurucu  (id + diğer 12 alan = 13 parametre) */
    public Project(int id,
                   String projectTopic, Date uploadStartDate, Date uploadEndDate,
                   String courseName, String advisorName,
                   String githubLink, String libraryLink,
                   String projectDescription, String projectImage,
                   String projectPublished, String publishLink, String projectAwards) {

        this.id                = id;
        this.projectTopic      = projectTopic;
        this.uploadStartDate   = uploadStartDate;
        this.uploadEndDate     = uploadEndDate;
        this.courseName        = courseName;
        this.advisorName       = advisorName;
        this.githubLink        = githubLink;
        this.libraryLink       = libraryLink;
        this.projectDescription= projectDescription;
        this.projectImage      = projectImage;
        this.projectPublished  = projectPublished;
        this.publishLink       = publishLink;
        this.projectAwards     = projectAwards;
    }

    /* Eğer DAO’nuz hâlâ id OLMADAN obje oluşturuyorsa bu 12’li kurucuyu
       ister­seniz bırakabilirsiniz; ama id’li versiyon eklenince sorun yok. */
    public Project(String projectTopic, Date uploadStartDate, Date uploadEndDate,
                   String courseName, String advisorName,
                   String githubLink, String libraryLink,
                   String projectDescription, String projectImage,
                   String projectPublished, String publishLink, String projectAwards) {
        this(0, projectTopic, uploadStartDate, uploadEndDate,
             courseName, advisorName, githubLink, libraryLink,
             projectDescription, projectImage, projectPublished, publishLink, projectAwards);
    }

    /* ---------- Getter + Setter’lar ---------- */
    public int    getId()                      { return id; }
    public void   setId(int id)                { this.id = id; }

    public String getProjectTopic()            { return projectTopic; }
    public void   setProjectTopic(String t)    { this.projectTopic = t; }

    public Date   getUploadStartDate()         { return uploadStartDate; }
    public void   setUploadStartDate(Date d)   { this.uploadStartDate = d; }

    public Date   getUploadEndDate()           { return uploadEndDate; }
    public void   setUploadEndDate(Date d)     { this.uploadEndDate = d; }

    public String getCourseName()              { return courseName; }
    public void   setCourseName(String c)      { this.courseName = c; }

    public String getAdvisorName()             { return advisorName; }
    public void   setAdvisorName(String a)     { this.advisorName = a; }

    public String getGithubLink()              { return githubLink; }
    public void   setGithubLink(String g)      { this.githubLink = g; }

    public String getLibraryLink()             { return libraryLink; }
    public void   setLibraryLink(String l)     { this.libraryLink = l; }

    public String getProjectDescription()      { return projectDescription; }
    public void   setProjectDescription(String d){ this.projectDescription = d; }

    public String getProjectImage()            { return projectImage; }
    public void   setProjectImage(String i)    { this.projectImage = i; }

    public String getProjectPublished()        { return projectPublished; }
    public void   setProjectPublished(String p){ this.projectPublished = p; }

    public String getPublishLink()             { return publishLink; }
    public void   setPublishLink(String l)     { this.publishLink = l; }

    public String getProjectAwards()           { return projectAwards; }
    public void   setProjectAwards(String a)   { this.projectAwards = a; }
}
