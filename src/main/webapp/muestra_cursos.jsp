<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="./css/bootstrap.min.css" />
        <title>CURSOS ACUALES</title>
    </head>
    <body>
        <h1>CURSOS</h1>
        <ul>
            <%
                Class.forName("com.mysql.jdbc.Driver");
                String consulta1 = "SELECT nom_curs, desc_curs, id_curs, inscriptos FROM tb_curs";
                String consultaTablaHorarios = "SELECT tb_dias.dia AS dia,"
                                              +"       tb_horarios.hr_inicio AS hr_inicio," 
                                              +"       tb_horarios.hr_fin AS hr_fin,"
                                              +"       tb_curs.desc_curs AS desc_curs,"
                                              +"       tb_curs.inscriptos AS inscriptos "
                                              +"FROM tb_horarios " 
                                              +"    JOIN tb_curs " 
                                              +"        ON tb_horarios.id_curs= tb_curs.id_curs " 
                                              +"    JOIN tb_dias " 
                                              +"        ON tb_horarios.id_dia= tb_dias.id_dia "
                                              +"    AND tb_curs.id_curs=?";
                String cDisponible = "style='color: green'";
                String cLleno = "style='color: red'";
                String cEspera = "style='color: yellow'";
                Connection conexion = null;
                PreparedStatement consultaCursos = null;
                PreparedStatement consultaHorarios = null;
                try {
                    conexion = DriverManager.getConnection("jdbc:mysql://localhost:3306/cfl414", "root", "");
                    consultaCursos = conexion.prepareStatement(consulta1);
                    ResultSet listaCursos = consultaCursos.executeQuery();
                    while (listaCursos.next()) {
                        consultaHorarios = conexion.prepareStatement(consultaTablaHorarios);
                        consultaHorarios.setString(1, listaCursos.getString("id_curs"));
                        ResultSet listaHorarios = consultaHorarios.executeQuery();
                        String color;
                        int cant = (Integer) listaCursos.getObject("inscriptos");
                        if (cant < 15){
                            color="green";                    
                        }else if (cant > 15 && cant <= 20){
                            color="yellow";
                        }else{
                            color="red";
                        }
                        out.println("<li style='color: " + color + "'>curso: " + listaCursos.getString("nom_curs") + "</li>");
                        out.println("detalle: " + listaCursos.getString("desc_curs") + "</br>");
                        out.println("inscriptos: " + cant + "</br>");
                        while (listaHorarios.next()){
                            out.print(listaHorarios.getString("dia") + "Inicia: " + listaHorarios.getString("hr_inicio") + "Fin: " + listaHorarios.getString("hr_fin"));
                        }
                        listaHorarios.close();
                    }
                    
                    listaCursos.close();
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("exepcion </br>");
                    out.println("detalle de la consulta: </br>");
                    out.println(consultaHorarios + "</br>");
                    out.println(consultaCursos + "</br>");
                } finally {
                    try {
                        consultaHorarios.close();
                        consultaCursos.close();
                        conexion.close();
                    } catch (Exception e) {
                    }
                }
            %>
            <%
                /*Class.forName("com.mysql.jdbc.Driver");
                String consulta1 = "SELECT nom_curs, desc_curs, id_curs, inscriptos FROM tb_curs";
                String cDisponible = "style='color: green'";
                String cLleno = "style='color: red'";
                String cEspera = "style='color: yellow'";
                Connection conexion = null;
                PreparedStatement consultaCursos = null;
                try {
                    conexion = DriverManager.getConnection("jdbc:mysql://localhost:3306/cfl414", "root", "");
                    consultaCursos = conexion.prepareStatement(consulta1);
                    ResultSet listaCursos = consultaCursos.executeQuery();
                    while (listaCursos.next()) {
                        String color;
                        int cant = (Integer) listaCursos.getObject("inscriptos");
                        if (cant < 15){
                            color="green";                    
                        }else if ( cant > 15 && cant <= 20){
                            color="yellow";
                        }else{
                            color="red";
                        }
                        out.println("<li style='color: " + color + "'>curso: " + listaCursos.getString("nom_curs") + "</li>");
                        out.println("<p>detalle: " + listaCursos.getString("desc_curs") + "</br>");
                        out.println("<p>inscriptos: " + cant + "</br>");
                    }
                    listaCursos.close();
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try {
                        consultaCursos.close();
                        conexion.close();
                    } catch (Exception e) {
                    }
                }/*
            %>
            <%/*
                Class.forName("com.mysql.jdbc.Driver");
                Connection conexion = DriverManager.getConnection("jdbc:mysql://localhost:3306/cfl414", "root", "");
                Statement a = conexion.createStatement();
                ResultSet listaCursos = a.executeQuery("SELECT nom_curs FROM tb_curs");
                while (listaCursos.next()) {
                    out.println("<li>curso: " + listaCursos.getString("nom_curs") + "</li>");                                               
                }
                conexion.close();*/
            %>
            <h3>Cargar curso</h3>
            <a href="alta_cursos.html">cargar 1 curso</a>
        </ul>
    </body>
</html>
