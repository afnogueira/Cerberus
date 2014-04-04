<%--
  ~ Cerberus  Copyright (C) 2013  vertigo17
  ~ DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
  ~
  ~ This file is part of Cerberus.
  ~
  ~ Cerberus is free software: you can redistribute it and/or modify
  ~ it under the terms of the GNU General Public License as published by
  ~ the Free Software Foundation, either version 3 of the License, or
  ~ (at your option) any later version.
  ~
  ~ Cerberus is distributed in the hope that it will be useful,
  ~ but WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  ~ GNU General Public License for more details.
  ~
  ~ You should have received a copy of the GNU General Public License
  ~ along with Cerberus.  If not, see <http://www.gnu.org/licenses/>.
--%>
<%@ page import="org.cerberus.entity.Project"%>
<%@ page import="org.apache.log4j.Level"%>
<%@ page import="org.cerberus.log.MyLogger"%>
<%@ page import="org.cerberus.exception.CerberusException"%>
<%@ page import="org.cerberus.dao.IApplicationDAO" %>
<%@ page import="org.cerberus.entity.Application" %>
<%@ page import="org.cerberus.dao.IInvariantDAO" %>
<%@ page import="org.cerberus.dao.IProjectDAO" %>
<%@ page import="org.cerberus.dao.impl.ApplicationDAO" %>
<%@ page import="org.cerberus.dao.impl.InvariantDAO" %>
<%@ page import="org.cerberus.dao.impl.ProjectDAO" %>
<%@ page import="org.springframework.context.ApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%--
  User: ip100003
  Date: 10-04-2013
  Time: 11:11
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>TestCase</title>
    
    <link href="css/jquery-editable.css" rel="stylesheet">
    <link href="css/jquery-ui.css" rel="stylesheet">
    <link href="css/jquery.dataTables.css" rel="stylesheet">
    <link href="css/jquery.dataTables_themeroller.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="css/crb_style.css">
    <link rel="stylesheet" type="text/css" href="css/elrte.min.css">
    <link rel="shortcut icon" type="image/x-icon" href="images/favicon.ico" />

    <style type="text/css">
        body {
            font-family: helvetica;
            font-size: 70%;
        }

        input {
            font-family: helvetica;
            font-size: 85%;
        }

        select {
            font-size: 85%;
        }

        .fields {
            background-color: #CAD3F1;
            border: 2px solid #8999C4;
            display: inline-block;
            border-radius: 15px;
            padding: 5px;
            margin-bottom: 3px;
            margin-top: 3px;
            width: 98%;
        }

        .field {
            /*position: relative;*/
            /*float: left;*/
            display: inline-block;
            padding-bottom: 5px;
            padding-left: 5px;
        }

        .field label {
            font-weight: bold;
            display: inline-block;
        }

        .field_countries {
            display: inline-block;
            text-align: center;
            font-size: xx-small;
        }

        h4 {
            color: blue;
            margin-top: 2px;
            margin-bottom: 2px;
            font-weight: bold;
        }

            /* Ajax Loader styles */
        .ajax_loader {
            background: url("images/spinner_squares_circle.gif") no-repeat center center transparent;
            width: 100%;
            height: 100%;
        }

        #generalParameters span {
            display: inline-block;
        }

        .separator {
            clear: both;
            border-bottom: 1px dashed #8999C4;
            padding-bottom: 2px;
        }

        thead th.country {
            padding: 3px 5px;
            width: 0.5%;
        }

        .country div {
            padding: 0px;
            font-weight: normal;
            font-size: x-small;
        }

        .tdCenter {
            text-align: center;
        }
        
        .propertiesCountryList {
            font-size: xx-small;
        }
        
        .properties_tbody {
            font-size: small;
        }
    </style>

    <script type="text/javascript" src="js/jquery-1.9.1.min.js"></script>
    <script type="text/javascript" src="js/jquery-ui-1.10.2.js"></script>
    <script type="text/javascript" src="js/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="js/jquery.dataTables.rowReordering.js"></script>
    <script type="text/javascript" src="js/jquery.dataTables.rowGrouping.js"></script>
    <script src="js/ajax-loader.js" type="text/javascript"></script>
    <script src="js/jquery-editable-poshytip.min.js" type="text/javascript"></script>
</head>
<body>
<%@ include file="include/header.jsp" %>

<%!
    List<Invariant> getListInvariantsFromName(IInvariantDAO invariantDAO, String name) {
        try {
            return invariantDAO.findListOfInvariantById(name);
        } catch(CerberusException cerberusException) {
            MyLogger.log(this.getClass().getName(), Level.ERROR, "Unable to retrieve Invariant "+name);
        }
        return new ArrayList<Invariant>();
    }

    String generateOptionsFromInvariantList(List<Invariant> invariants) {
        StringBuilder builder = new StringBuilder();
        for(Invariant invariant: invariants) {
            builder.append("<option value=\"")
                    .append(invariant.getValue())
                    .append("\">")
                    .append(invariant.getValue())
                    .append("</option>");
        }
        return builder.toString();
    } 
%>

<%
    ApplicationContext appContext = WebApplicationContextUtils.getWebApplicationContext(this.getServletConfig().getServletContext());
    IInvariantDAO invariantDAO = appContext.getBean(InvariantDAO.class);
    IApplicationDAO applicationDAO = appContext.getBean(ApplicationDAO.class);
    IProjectDAO projectDAO = appContext.getBean(ProjectDAO.class);
 
    List<Invariant> countries = getListInvariantsFromName(invariantDAO,"COUNTRY");
%>
<div id="loadParameters" class="fields">
    <div class="field">
        <label for="Test" style="width: 50px">Test</label>
        <select id="Test" name="Test" onchange="getTestCaseList(false);" style="width: 200px"></select>
    </div>
    <div class="field">
        <label for="TestCase" style="width: 70px">TestCase</label>
        <select id="TestCase" name="TestCase" style="width: 500px"></select>
    </div>
    <div class="field">
        <input type="button" onclick="JavaScript:loadTestCase()"
               value="Load"/>
    </div>
</div>

<br/>

<div id="generalParameters" class="fields">
    <div>
        <span style="color: blue; font-weight: bold; width: 150px">Execution Parameters</span>
        <span style="width: 150px">APP: [<span id="appValue"></span>]</span>
        <span style="width: 160px">GROUP: [<span id="groupValue"></span>]</span>
        <span style="width: 200px">STATUS: [<span id="statusValue"></span>]</span>
        <span style="width: 60px">ACT: [<span id="actValue"></span>]</span>
        <span style="width: 170px">Last Exe: [<span id="exeValue" style="font-style: italic"></span>]</span>
        <span style="width: 300px">Countries: [<span id="countriesValue"></span>]</span>
        <button onclick="$('#generalInformation').show();$('#generalParameters').hide()">+</button>
    </div>
</div>

<div id="generalInformation" class="fields" style="display: none">
<div id="testInformation">
    <h4>Test Information</h4>
    <button onclick="$('#generalParameters').show();$('#generalInformation').hide()">-</button>
    <div>
        <div class="field">
            <label for="editTest" style="width: 100px">Test</label><br/>
            <input id="editTest" name="editTest" type="text"/>
        </div>
        <div class="field">
            <label for="editTestCase" style="width: 100px">TestCase</label><br/>
            <input id="editTestCase" name="editTestCase" type="text" style="width: 100%"/>
        </div>
        <div class="field">
            <label for="editDescription" style="width: 960px">Test Description</label><br/>
            <input id="editDescription" name="editDescription" type="text" style="width: 960px"
                   readonly="readonly"/>
        </div>
        <div class="separator"></div>
    </div>
</div>
<div id="testCaseInformation">
    <h4>TestCase Information</h4>

    <div>
        <div class="field">
            <label for="origin" style="width: 100px">Origin</label><br/>
            <input id="origin" name="origin" type="text" readonly="readonly"/>
        </div>
        <div class="field">
            <label for="refOrigin" style="width: 100px">RefOrigin</label><br/>
            <input id="refOrigin" name="refOrigin" type="text" readonly="readonly"/>
        </div>
        <div class="field">
            <label for="creator" style="width: 100px">Creator</label><br/>
            <input id="creator" name="creator" type="text" readonly="readonly"/>
        </div>
        <div class="field">
            <label for="implementer" style="width: 100px">Implementer</label><br/>
            <input id="implementer" name="implementer" type="text"/>
        </div>
        <div class="field">
            <label for="lastModifier" style="width: 100px">Last Modifier</label><br/>
            <input id="lastModifier" name="lastModifier" type="text" readonly="readonly"/>
        </div>
        <div class="field">
            <label for="project" style="width: 100px">Project</label><br/>
            <select id="project" name="project" style="width: 100px">
                <%
                    for (Project project : projectDAO.findAllProject()) {
                        out.println("<option value=\"" + project.getIdProject() + "\">[" + project.getIdProject() + "] " + project.getDescription() + "</option>");
                    }
                %>
            </select>
        </div>
        <div class="field">
            <label for="ticket" style="width: 100px">Ticket</label><br/>
            <input id="ticket" name="ticket" type="text"/>
        </div>

        <div class="separator"></div>
    </div>
</div>
<div id="testCaseParameters">
    <h4>TestCase Parameters</h4>

    <div>
        <div>
            <div class="field">
                <label for="application" style="width: 140px">Application</label><br/>
                <select id="application" name="application" style="width: 140px">
                    <%
                        for (Application app : applicationDAO.findAllApplication()) {
                            out.println("<option value=\"" + app.getApplication() + "\">" + app.getApplication() + "</option>");
                        }
                    %>
                </select>
            </div>
            <div class="field">
                <label for="editRunQA" style="width: 75px">Run QA</label><br/>
                <select id="editRunQA" name="editRunQA" style="width: 75px">
                </select>
            </div>
            <div class="field">
                <label for="editRunUAT" style="width: 75px">Run UAT</label><br/>
                <select id="editRunUAT" name="editRunUAT" style="width: 75px">
                </select>
            </div>
            <div class="field">
                <label for="editRunPROD" style="width: 75px">Run PROD</label><br/>
                <select id="editRunPROD" name="editRunPROD" style="width: 75px">
                </select>
            </div>
            <div class="field">
                <label for="editPriority" style="width: 75px">Prio</label><br/>
                <select id="editPriority" name="editPriority" style="width: 75px">
                </select>
            </div>
            <div class="field">
                <label for="editGroup" style="width: 140px">Group</label><br/>
                <select id="editGroup" name="editGroup" style="width: 140px">
                </select>
            </div>
            <div class="field">
                <label for="editStatus" style="width: 140px">Status</label><br/>
                <select id="editStatus" name="editStatus" style="width: 140px">
                </select>
            </div>
            <div class="field" style="padding-bottom: 0px;" id="countryFields">
            </div>
        </div>
        <div>
            <div class="field">
                <label for="desc" style="width: 290px">TestCase Short Description</label><br/>
                <input id="desc" name="desc" type="text" style="width: 290px"/>
                <br/>
                <label for="value" style="width: 290px">Detailed Description / Value Expected</label><br/>
                <textarea id="value" name="value" style="width: 290px" rows="7"></textarea>
            </div>
            <div class="field">
                <label for="howto" style="width: 790px">How To</label><br/>
                <textarea id="howto" name="howto" style="width: 790px" rows="9"></textarea>
            </div>
        </div>

        <div class="separator"></div>
    </div>
</div>

<div id="activationCriteria">
    <h4>Activation Criteria</h4>

    <div>
        <div class="field">
            <label for="editTcActive" style="width: 50px">Act</label><br/>
            <select id="editTcActive" name="editTcActive" style="width: 50px">
            </select>
        </div>
        <div class="field">
            <label for="editFromBuild" style="width: 90px">From Sprint</label><br/>
            <select id="editFromBuild" class="editBuild" name="editFromBuild" style="width: 90px">
            </select>
        </div>
        <div class="field">
            <label for="editFromRev" style="width: 100px">From Rev</label><br/>
            <select id="editFromRev" class="editRevision" name="editFromRev" style="width: 100px">
            </select>
        </div>
        <div class="field">
            <label for="editToBuild" style="width: 90px">To Sprint</label><br/>
            <select id="editToBuild" class="editBuild" name="editToBuild" style="width: 90px">
            </select>
        </div>
        <div class="field">
            <label for="editToRev" style="width: 100px">To Rev</label><br/>
            <select id="editToRev" class="editRevision" name="editToRev" style="width: 100px">
            </select>
        </div>
        <div class="field">
            <label for="lastExecution" style="width: 390px">Last Execution Status</label><br/>
            <span id="lastExecution"></span>
        </div>
        <div class="field">
            <label for="editBugID" style="width: 70px">Bug ID</label><br/>
            <input id="editBugID" name="editBugID" type="text"/>
        </div>
        <div class="field">
            <label for="" style="width: 50px">Link</label><br/>

        </div>
        <div class="field">
            <label for="editTargetBuild" style="width: 80px">Target Sprint</label><br/>
            <select id="editTargetBuild" class="editBuild" name="editTargetBuild" style="width: 80px">
            </select>
        </div>
        <div class="field">
            <label for="editTargetRev" style="width: 80px">Target Rev</label><br/>
            <select id="editTargetRev" class="editRevision" name="editTargetRev" style="width: 80px">
            </select>
        </div>
        <div class="field" style="clear: left">
            <label for="comment" style="width: 650px">Comment</label><br/>
            <input id="comment" name="comment" type="text" style="width: 650px"/>
        </div>

        <div class="separator"></div>
    </div>
</div>
<div>
    <div class="field" style="padding-top: 3px">
        <input id="submitButtonInformation" type="button" value="Save TestCase Info" name="submitInformation">
    </div>
</div>
</div>

<div id="automationScript">
    <!--h2>TestCase Automation Script</h2-->

    <div>
        <h2>Properties</h2>

        <div id="divProperties" class="fields">
            <table id="properties" class="display">
                <thead>
                    <tr>
                        <th rowspan="2">Property</th>
                        <th rowspan="1" colspan="" class="ui-state-default propertiesCountryListCol">
                            <div class="DataTables_sort_wrapper">Country</div>
                        </th>
                        <th rowspan="2" style="text-align: center">Type</th>
                        <th rowspan="2" style="text-align: center">DTB</th>
                        <th rowspan="2" style="">Value</th>
                        <th rowspan="2" style="">Value 2</th>
                        <th rowspan="2" style="text-align: center">Length</th>
                        <th rowspan="2" style="text-align: center">RowLimit</th>
                        <th rowspan="2" style="text-align: center">Nature</th>
                    </tr>
                    <tr class="propertiesCountryList"></tr>
                </thead>
                <tbody class="properties_tbody">
                </tbody>
            </table>
        </div>
    </div>
    <div id="divSteps">
    </div>
</div>

</body>
<script type="text/javascript">

    var load = new ajaxLoader("#loadParameters");
    $.get('GetShortTests', function (data) {
        for (var i = 0; i < data.testsList.length; i++) {
            $("#Test").append($("<option></option>")
                    .attr("value", data.testsList[i])
                    .text(data.testsList[i]));
        }
        $("#Test").val("<%=request.getParameter("Test")%>");
        getTestCaseList(false);
    });

    function setOptionsToSelect(select,options) {
        select.empty();
        for (var i = 0; i < options.length; i++) {
            select.append($("<option></option>")
                    .attr("value", options[i])
                    .text(options[i]));
        }
    }

    
    $.get('GetInvariantsForTest', function (data) {
        setOptionsToSelect($('#editRunQA'),data.RUNQA);
        setOptionsToSelect($('#editRunUAT'),data.RUNUAT);
        setOptionsToSelect($('#editRunPROD'),data.RUNPROD);
        setOptionsToSelect($('#editPriority'),data.PRIORITY);
        setOptionsToSelect($('#editGroup'),data.GROUP);
        setOptionsToSelect($('#editStatus'),data.TCSTATUS);
        setOptionsToSelect($('#editTcActive'),data.TCACTIVE);
    
    /*
        if(data['BUILD'] && data['BUILD'].length > 0) {
            $('.editBuild').each(function(elt){
                setOptionsToSelect($(elt),data.BUILD);
            });
        }

        if(data['REVISION'] !== null && data['REVISION'].length > 0) {
            $('.editRevision').each(function(elt){
                setOptionsToSelect($(elt),data.REVISION);
            });
        }
        */

        $('#countryFields').empty();
        for (var i = 0; i < data.COUNTRY.length; i++) {
            var input = $('<input type="checkbox" name="testcase_country_general">').attr("value", data.COUNTRY[i]);
            var div = $("<div class=\"field_countries\">").append(
                    $('<label>').text(data.COUNTRY[i]).append('<br/>').append(input));
            $('#countryFields').append(div);
        }
    });

    load.remove();
    function getTestCaseList(bool) {
        bool = bool || false;
        var load = new ajaxLoader("#loadParameters");
        $("#TestCase").empty();
        $.get('GetTestCaseForTest', {test: $("#Test").val()}, function (data) {
            for (var i = 0; i < data.testCaseList.length; i++) {
                $("#TestCase").append($("<option></option>")
                        .attr("value", data.testCaseList[i].testCase)
                        .text(data.testCaseList[i].description));
            }
            if (bool) {
                $("#TestCase option[value='<%=request.getParameter("TestCase")%>']").attr("selected", "selected");
            }
            load.remove();
            //loadTestCase();
        });
    }

    function loadTestCase() {
        var load = new ajaxLoader("#automationScript");

        $.get('GetTestCase', {test: $("#Test").val(), testcase: $("#TestCase").val()}, function (data) {
            $('#divSteps').empty().append("<h2>Steps</h2>");
            
            // warning delete headers !!
            //$('#properties').empty();

            $("#appValue").text(data.application);
            $("#groupValue").text(data.group);
            $("#statusValue").text(data.status);
            if (data.active == true) {
                $("#actValue").text("Y");
            } else {
                $("#actValue").text("N");
            }
            $("#exeValue").text(data.lastExecutionStatus);

            //Test Information
            $("#editTest").val(data.test);
            $("#editTestCase").val(data.testcase);
            $("#origin").val(data.origin);
            $("#refOrigin").val(data.refOrigin);
            $("#creator").val(data.creator);
            $("#implementer").val(data.implementer);
            $("#lastModifier").val(data.lastModifier);
            $("#project").val(data.project);
            $("#ticket").val(data.ticket);
            //TestCase Information
            $("#application").val(data.application);
            $("#editRunQA").val(data.runQA);
            $("#editRunUAT").val(data.runUAT);
            $("#editRunPROD").val(data.runPROD);
            $("#editPriority").val(data.priority);
            $("#editGroup").val(data.group);
            $("#editStatus").val(data.status);
            //TODO check countries
            var propertiesCountryInputList = $("<div></div>");
            $('.propertiesCountryList').empty();
            $('.propertiesCountryListCol').attr('colspan',data.countriesList.length);
            for (var i = 0; i < data.countriesList.length; i++) {
                $("input[name=testcase_country_general][value=" + data.countriesList[i] + "]").prop('checked', true);
                $("#countriesValue").text($("#countriesValue").text() + data.countriesList[i] + "-");
                propertiesCountryInputList
                    .append($('<td class="property_country"></td>')
                        .append($('<input type="checkbox" name="list_countries">')
                            .val(data.countriesList[i])
                            .addClass("property_country_"+data.countriesList[i])
                        )
                    );

                $('.propertiesCountryList').append(
                        $('<th rowspan="1" colspan="1" class="country"></th>')
                            .text(data.countriesList[i])
                       );

            }

            $("#desc").val(data.shortDescription);
            $("#value").val(data.description);
            $("#howto").val(data.howTo);
            //Activation Criteria
            $("#editTcActive").val(data.active);
            $("#editFromBuild").val(data.fromSprint);
            $("#editFromRev").val(data.fromRevision);
            $("#editToBuild").val(data.toSprint);
            $("#editToRev").val(data.toRevision);
            $("#lastExecution").val(data.lastExecutionStatus);
            $("#editBugID").val(data.bugID);
            $("#editTargetBuild").val(data.targetSprint);
            $("#editTargetRev").val(data.targetRevision);
            $("#comment").val(data.comment);

            var propertiesTbody = $('tbody.properties_tbody').empty();
            var trProperty = $('<tr class="property_line"></tr>')
                        .append($('<td class="property_name editable"></td>'))
                        .append($('<td class="property_type editableType tdCenter" data-type="select"></td>'))
                        .append($('<td class="property_db editableDB" data-type="select"></td>'))
                        .append($('<td class="property_value1 editable"></td>'))
                        .append($('<td class="property_value2 editable"></td>'))
                        .append($('<td class="property_length editable"></td>'))
                        .append($('<td class="property_rowlimit editable"></td>'))
                        .append($('<td class="property_nature editableNature" data-type="select"></td>'));
            for(var i=0;i< data.properties.length;i++) {
                var tr = trProperty.clone();

                var pk={test: data.test, testcase: data.testcase, property: data.properties[i].property};

                if(i%2===0) {
                    tr.addClass('odd');
                } else {
                    tr.addClass('even');
                }

                tr.find('.property_name').text(data.properties[i].property).data("name","Property").data("pk",pk);
                tr.find('.property_type').text(data.properties[i].type).data("name","Type").data("pk",pk);
                tr.find('.property_db').text(data.properties[i].database).data("name","Database").data("pk",pk);
                tr.find('.property_value1').text(data.properties[i].value1).data("name","Value1").data("pk",pk);
                tr.find('.property_value2').text(data.properties[i].value2).data("name","Value2").data("pk",pk);
                tr.find('.property_length').text(data.properties[i].length).data("name","Length").data("pk",pk);
                tr.find('.property_rowLimit').text(data.properties[i].rowLimit).data("name","RowLimit").data("pk",pk);
                tr.find('.property_nature').text(data.properties[i].nature).data("name","Nature").data("pk",pk);

                tr.find(".property_name").after(propertiesCountryInputList.html());
                for(var j=0;j< data.properties[i].countriesSelected.length;j++){
                    tr.find('.property_country_'+data.properties[i].countriesSelected[j])
                                .attr("checked","checked");
                }

                propertiesTbody.append(tr);
                
            }
            
            //turn to inline mode
            $.fn.editable.defaults.mode = 'inline';
            $('.editable').editable({
                url: 'UpdatePropertyForTestCase'
            });

            $.getJSON('GetInvariantList',{idName: "PROPERTYTYPE",type: "editable"}, function(data) {
                $('.editableType').editable({
                    url: 'UpdatePropertyForTestCase',
                    source: data.source
                });

            });

            $.getJSON('GetInvariantList',{idName: "PROPERTYDATABASE",type: "editable"}, function(data) {
                $('.editableDB').editable({
                    url: 'UpdatePropertyForTestCase',
                    source: data.source
                });

            });

            $.getJSON('GetInvariantList',{idName: "PROPERTYNATURE",type: "editable"}, function(data) {
                $('.editableNature').editable({
                    url: 'UpdatePropertyForTestCase',
                    source: data.source
                });

            });

            $('.country div').removeClass('DataTables_sort_wrapper');

            var trActions = $('<tr class="action_line"></tr>')
                    .append('<td class="action_sequence"></td>')
                    .append('<td class="action_action aditableAction" data-type="select"></td>')
                    .append('<td class="action_object editable"></td>')
                    .append('<td class="action_property editable"></td>')
                    .append('<td class="action_description editable"></td>')
                    .append('<td class="action_delete"></td>');          

            for (var i = 0; i < data.list.length; i++) {
                //alert('<div id="divStep' + data.list[i].number + '"> <div> <span>' + data.list[i].number + '</span> <input type="text" style="width: 500px" value="' + data.list[i].name + '"/> </div> <div> <div> <table id="step' + data.list[i].number + '" class="display" style="font-size: small"> <thead> <tr> <th style="width: 20px; text-align: center">Seq</th> <th style="width: 160px">Action</th> <th style="width: 640px">Object</th> <th style="width: 210px">Property</th> <th style="width: 40px">Fatal</th> </tr> </thead> <tbody style="font-size: x-small"> </tbody> <tfoot></tfoot> </table> </div> </div></div>');
                $('#divSteps').append('<div id="divStep' + data.list[i].number + '" class="fields"> <div> <span>' + data.list[i].number + '</span> <input type="text" size="100%" value="' + data.list[i].name + '"/> </div> <div> <div> <table id="step' + data.list[i].number + '" class="display"> <thead> <tr> <th style="text-align: center">Seq</th> <th >Action</th> <th>Object</th> <th>Property</th><th>Description</th> <th>Fatal</th> </tr> </thead> <tbody> </tbody> <tfoot></tfoot> </table> </div> </div></div>');

                $('#step' + data.list[i].number).dataTable({
                    "bJQueryUI": true,
                    "bPaginate": false,
                    "bLengthChange": false,
                    "bFilter": false,
                    "bInfo": false,
                    "bAutoWidth": false,
                    "aaData": data.list[i].actions,
                    "aoColumns": [
                        { "mDataProp": "sequence" },
                        { "mDataProp": "action" },
                        { "mDataProp": "object" },
                        { "mDataProp": "property" },
                        { "mDataProp": "description" },
                        { "mDataProp": "controls" },
                        { "mDataProp": "fatal", fnRender: function (o, v) {
                            if (v === true) {
                                return "Y";
                            } else if (v === false) {
                                return "N";
                            } else {
                                return "";
                            }
                        } }
                    ],
                    "fnCreatedRow": function (nRow, aData, iDataIndex) {
                        nRow.id = iDataIndex;
                    },
                    "bDestroy": true
                }).rowReordering({sURL: './UpdateTestCase?test='+$("#Test").val()+'&testcase='+$("#TestCase").val()+'&step='+data.list[i].number,
                                    sRequestType: "GET",
                                    fnAlert: function(message) { alert(message); }
                                });
            }
        
            load.remove();
        });
        
        function generatePk(element) {
            alert($(element).html());
        }
        
    }
</script>
</html>