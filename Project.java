package project;

import java.sql.Date;

public class Project {

    /* — Alanlar — */
    private int id;
    private String projectTopic;
    private Date uploadStartDate;
    private Date uploadEndDate;
    private String courseName;
    private String advisorName;
    private String uploaderName;
    private String githubLink;
    private String libraryLink;
    private String projectDescription;
    private String projectImage;
    private String projectFile;          // ←  ZIP adı
    private String projectPublished;
    private String publishLink;
    private String projectAwards;

    /* — Kurucular — */
    public Project() {
    }

    public Project(int id,
            String projectTopic, Date uploadStartDate, Date uploadEndDate,
            String courseName, String advisorName, String uploaderName,
            String githubLink, String libraryLink,
            String projectDescription, String projectImage, String projectFile,
            String projectPublished, String publishLink, String projectAwards) {

        this.id = id;
        this.projectTopic = projectTopic;
        this.uploadStartDate = uploadStartDate;
        this.uploadEndDate = uploadEndDate;
        this.courseName = courseName;
        this.advisorName = advisorName;
        this.uploaderName = uploaderName;
        this.githubLink = githubLink;
        this.libraryLink = libraryLink;
        this.projectDescription = projectDescription;
        this.projectImage = projectImage;
        this.projectFile = projectFile;
        this.projectPublished = projectPublished;
        this.publishLink = publishLink;
        this.projectAwards = projectAwards;
    }

    public Project(String projectTopic, Date uploadStartDate, Date uploadEndDate,
            String courseName, String advisorName, String uploaderName,
            String githubLink, String libraryLink,
            String projectDescription, String projectImage, String projectFile,
            String projectPublished, String publishLink, String projectAwards) {
        this(0, projectTopic, uploadStartDate, uploadEndDate,
                courseName, advisorName, uploaderName,
                githubLink, libraryLink,
                projectDescription, projectImage, projectFile,
                projectPublished, publishLink, projectAwards);
    }

    /* — Getter/Setter — */
    public int getId() {
        return id;
    }

    public void setId(int v) {
        id = v;
    }

    public String getProjectTopic() {
        return projectTopic;
    }

    public void setProjectTopic(String v) {
        projectTopic = v;
    }

    public Date getUploadStartDate() {
        return uploadStartDate;
    }

    public void setUploadStartDate(Date v) {
        uploadStartDate = v;
    }

    public Date getUploadEndDate() {
        return uploadEndDate;
    }

    public void setUploadEndDate(Date v) {
        uploadEndDate = v;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String v) {
        courseName = v;
    }

    public String getAdvisorName() {
        return advisorName;
    }

    public void setAdvisorName(String v) {
        advisorName = v;
    }

    public String getUploaderName() {
        return uploaderName;
    }

    public void setUploaderName(String uploaderName) {
        this.uploaderName = uploaderName;
    }

    public String getGithubLink() {
        return githubLink;
    }

    public void setGithubLink(String v) {
        githubLink = v;
    }

    public String getLibraryLink() {
        return libraryLink;
    }

    public void setLibraryLink(String v) {
        libraryLink = v;
    }

    public String getProjectDescription() {
        return projectDescription;
    }

    public void setProjectDescription(String v) {
        projectDescription = v;
    }

    public String getProjectImage() {
        return projectImage;
    }

    public void setProjectImage(String v) {
        projectImage = v;
    }

    public String getProjectFile() {
        return projectFile;
    }

    public void setProjectFile(String v) {
        projectFile = v;
    }

    public String getProjectPublished() {
        return projectPublished;
    }

    public void setProjectPublished(String v) {
        projectPublished = v;
    }

    public String getPublishLink() {
        return publishLink;
    }

    public void setPublishLink(String v) {
        publishLink = v;
    }

    public String getProjectAwards() {
        return projectAwards;
    }

    public void setProjectAwards(String v) {
        projectAwards = v;
    }
}
