<!-- Edit test data lib-->
<div data-backdrop="static" class="modal fade center width1000" id="addTestDataLibModal" tabindex="-1" role="dialog" aria-labelledby="addTestDataLibModalLabel" aria-hidden="true">
    <div class="modal-dialog nomargintop nomarginbottom width1000">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="addTestDataLibModalLabel">Add New Sub Data Entry</h4>                
            </div>
            <div class="modal-body"> 
                <form id="addTestDataLibModalForm" name="addTestDataLibModalForm"  title="Add TestDataLib Entry" role="form">

                    <!--  The form that will be parsed by jQuery before submit  -->
                    <div id="tabs" class="center container width800">
                        <!-- messages area-->
                        <div id="DialogMessagesArea" class="width800">
                            <div class="alert" id="DialogMessagesAlert"  style="display:none;">
                                <strong><span class="alert-description" id="DialogAlertDescription"></span></strong>
                                <button type="button" class="close" data-hide="alert"  aria-hidden="true">
                                    <span class="glyphicon glyphicon-remove alert-right alert-close pull-right"></span>
                                </button>
                            </div>
                        </div>
                        <!-- tabs definition-->
                        <ul id="tabs" class="nav nav-tabs" data-tabs="tabs">
                            <li class="active"><a data-toggle="tab" href="#tabs-1">Entry</a></li>
                            <li><a data-toggle="tab" href="#tabs-2" id="tab2Text">Sub data (0 entries) </a></li>
                        </ul>
                        <div class="tab-content">   
                            <div class="center marginTop25 tab-pane fade in active" id="tabs-1">
                                <input type="hidden" value="-1" id="ID" name="ID" class="ncdetailstext" />
                                <div id="panelCommon" class="row">
                                    <div id="" class="form-group col-xs-6">
                                        <label for="Name">Name</label>
                                        <input type="text" class="form-control" name="Name" id="Name" maxlength="200" />
                                    </div> 
                                    <div class="form-group col-xs-6">
                                        <label for="Type">Select Type</label>
                                        <select class="form-control"  id="Type" name="Type">

                                        </select>

                                    </div>  
                                </div>
                                <!--group infomation -->
                                <div class="row">
                                    <div class="form-group col-xs-6">
                                        <label>Choose an existing group</label>
                                        <span>
                                            <select class="form-control"  id="Group" name="Group">                                                
                                            </select>
                                        </span>                                         
                                    </div> 
                                    <div class="form-group col-xs-6">
                                        <label for="GroupInput">or enter new group</label>
                                        <input id="GroupInput" name="Group" class="form-control" type="text" maxlength="200"  />     
                                    </div>                  
                                </div>
                                
                                <div class="row" style="margin-top:10px">
                                    <div class="form-group col-xs-4">
                                            <label for="System">System</label>
                                            <input type="hidden" id="systemAll" name="systemAll"  value="false" />
                                            <select class="multiselectelement form-control" multiple="multiple" id="System" >
                                            </select>                                            
                                      
                                    </div>        
                                    <div class="form-group col-xs-4">
                                        <label for="Environment">Environment</label>
                                        <input type="hidden" id="environmentAll" name="environmentAll"  value="false" />
                                        <div>
                                            <select class="multiselectelement form-control" multiple="multiple" id="Environment">
                                            </select>  
                                        </div>
                                    </div>    
                                    <div class="form-group col-xs-4">
                                        <label for="Country">Country</label>
                                        <input type="hidden" id="countryAll" name="countryAll" value="false" />
                                        <div>
                                            <select class="multiselectelement form-control" multiple="multiple" id="Country">
                                            </select>  
                                        </div>    
                                    </div>    
                                </div>  
                                
                                <!--description-->
                                <div class="row">
                                    <div class="form-group col-xs-12">
                                        <label for="Description">Description</label>
                                        <textarea id="EntryDescription" name="EntryDescription"   
                                                  class="form-control"></textarea> 
                                    </div>
                                </div>           
                                <!--SQL-->
                                <div id="panelSQL" name="panelData" style="display:none">
                                    <div class="row form-group  col-xs-6"> 
                                        <label for="Database">Database</label> 
                                        <select class="form-control" id="Database" name="Database">
                                        </select> 
                                    </div>    
                                    <div class="row">
                                        <div class="form-group col-xs-12"> 
                                            <label for="Script">Script</label> 
                                            <textarea id="Script" name="Script" 
                                                      class="form-control"></textarea>     
                                        </div>                       
                                    </div>

                                </div>
                                <!--SOAP-->
                                <div id="panelSOAP" name="panelData" style="display:none">
                                    <div class="row">
                                        <div class="form-group col-xs-6" >
                                            <label for="ServicePath">Service Path</label>
                                            <input id="ServicePath" name="ServicePath"  class="form-control" maxlength="250"  />  
                                        </div>
                                        <div class="form-group col-xs-6">
                                            <label for="Method">Method</label>
                                            <input id="Method" name="Method" class="form-control" maxlength="45"  />
                                        </div>
                                    </div>    
                                    <div class="form-group">
                                        <label for="Envelope">Envelope</label>                    
                                        <textarea id="Envelope" name="Envelope" 
                                                      class="form-control"></textarea>     
                                    </div> 

                                </div>   
                            </div>       
                            <div class="center tab-pane fade marginTop25" id="tabs-2">
                                <div id="panelSubData" name="panelSubData">
                                    <div class="row">
                                        <div class="col-xs-12">
                                            <table class="table table-bordered table-hover nomarginbottom" id="addSubDataTable">
                                                <thead>
                                                    <tr>
                                                        <th></th>
                                                        <th class="text-center">Sub data</th>
                                                        <th class="text-center" id="labelSubdataEntry">Value</th>
                                                        <th class="text-center">Description</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="addSubDataTableBody">

                                                </tbody>
                                            </table>
                                            <div class="nomargintop">
                                                <a id="newSubData_addRow" class="pull-left btn btn-link manageRowsFont">Add new</a>
                                                <a id='newSubData_deleteAll' class="pull-right btn btn-link manageRowsFont">Delete All</a>
                                            </div>
                                        </div>
                                    </div>  
                                </div>   
                            </div>   
                        </div> 
                    </div> 
                </form> 

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                <button type="button" id="addTestDataLibButton" class="btn btn-primary">Add</button>
            </div>
        </div>
    </div>
</div>
<!--end view data modal -->