package project;

import java.sql.Date;

public class Project {
    private String projectTopic;
    private Date uploadStartDate;
    private Date uploadEndDate;
    private String courseName;
    private String advisorName;
    private String githubLink;
    private String libraryLink;      // Yeni alan: Kütüphane Linki
    private String projectDescription;
    private String projectImage;     // Dosya adı veya yolu

    // Yeni eklenen alanlar
    private String projectPublished; // "yes" veya "no"
    private String projectAwards;    // "1" ile "5" arası değer

    // Parametresiz Constructor
    public Project() {
    }

    // Parametreli Constructor (Yeni alanlar eklendi)
    public Project(String projectTopic, Date uploadStartDate, Date uploadEndDate, 
                   String courseName, String advisorName, String githubLink, String libraryLink,
                   String projectDescription, String projectImage,
                   String projectPublished, String projectAwards) {
        this.projectTopic = projectTopic;
        this.uploadStartDate = uploadStartDate;
        this.uploadEndDate = uploadEndDate;
        this.courseName = courseName;
        this.advisorName = advisorName;
        this.githubLink = githubLink;
        this.libraryLink = libraryLink;
        this.projectDescription = projectDescription;
        this.projectImage = projectImage;
        this.projectPublished = projectPublished;
        this.projectAwards = projectAwards;
    }

    // Getter ve Setter metodları
    public String getProjectTopic() {
        return projectTopic;
    }

    public void setProjectTopic(String projectTopic) {
        this.projectTopic = projectTopic;
    }

    public Date getUploadStartDate() {
        return uploadStartDate;
    }

    public void setUploadStartDate(Date uploadStartDate) {
        this.uploadStartDate = uploadStartDate;
    }

    public Date getUploadEndDate() {
        return uploadEndDate;
    }

    public void setUploadEndDate(Date uploadEndDate) {
        this.uploadEndDate = uploadEndDate;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public String getAdvisorName() {
        return advisorName;
    }

    public void setAdvisorName(String advisorName) {
        this.advisorName = advisorName;
    }

    public String getGithubLink() {
        return githubLink;
    }

    public void setGithubLink(String githubLink) {
        this.githubLink = githubLink;
    }

    public String getLibraryLink() {
        return libraryLink;
    }

    public void setLibraryLink(String libraryLink) {
        this.libraryLink = libraryLink;
    }

    public String getProjectDescription() {
        return projectDescription;
    }

    public void setProjectDescription(String projectDescription) {
        this.projectDescription = projectDescription;
    }

    public String getProjectImage() {
        return projectImage;
    }

    public void setProjectImage(String projectImage) {
        this.projectImage = projectImage;
    }
    
    public String getProjectPublished() {
        return projectPublished;
    }

    public void setProjectPublished(String projectPublished) {
        this.projectPublished = projectPublished;
    }

    public String getProjectAwards() {
        return projectAwards;
    }

    public void setProjectAwards(String projectAwards) {
        this.projectAwards = projectAwards;
    }
}
