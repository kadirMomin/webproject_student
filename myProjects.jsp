<%@ page contentType="text/html; charset=UTF-8" language="java"
         import="java.util.*, project.Project, project.ProjectDAO" %>
<%
  String user = (String) session.getAttribute("user");
  if(user==null){ response.sendRedirect("index2.jsp"); return; }

  String published = request.getParameter("published"); // yes | no
  List<Project> list = new ProjectDAO().getProjectsByUserName(user);
  List<Project> filtered = new ArrayList<>();
  for(Project p:list)
      if(published.equalsIgnoreCase(p.getProjectPublished())) filtered.add(p);
%>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Projelerim</title></head><body>
<h2><%= "yes".equals(published) ? "Onaylanan" : "Onay Bekleyen" %> Projelerim</h2>
<table border="1"><tr><th>Konu</th><th>Durum</th></tr>
<% for(Project p:filtered){ %>
<tr><td><%= p.getProjectTopic() %></td><td><%= p.getProjectPublished() %></td></tr>
<% } %></table>
<a href="courses.jsp">← Geri</a>
</body></html>
