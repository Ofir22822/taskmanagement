<%@ Page Title="Tasks" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Tasks.aspx.cs" Inherits="TaskManagementSystem.Tasks" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script>
        $(document).ready(function () {
            //set css bootsrap classes for pager
            var pager = $("tr[class*='pagination']");
            pager.find("td:first").addClass("m-auto");
            pager.find("table").find("td").addClass("page-item p-0");
            pager.find("table").find("td").find("a").addClass("page-link");
            pager.find("table").find("td").find("span").addClass("page-link");
            (pager.find("table").find("td").find("span")).parent("td").addClass("page-item active");
        });

        //show task details on click
        function showTask(taskId) {
            var task = document.getElementById("taskDetails" + taskId);
            if (task != undefined) {
                $("#taskDetails" + taskId).slideToggle("slow");
            }
        }

        //clear text in new task modal, and disply modal
        function newTask() {
            $("input[id*='btnSave']").attr("class", "d-none");               //hide create button on modal
            $("input[id*='btnCreate']").attr("class", "btn btn-primary");    //show save button on modal

            $("select[id*='mdlPriority']").val(1);
            $("input[id*='mdlTitle']").val("");                             //set Task details in modal window
            $("input[id*='mdlDueDate']").val("<%=DateTime.Now.ToString("yyyy-MM-dd")%>");
            $("textarea[id*='mdlDetails']").val("");
            $("input[id*='mdlID']").val("");
            $("input[id*='mdlMsg']").val("");
            $('#editModal').modal({ show: true });
        }

        //show confim massage for approving task delete
        function deleteTask(taskID) {
            var msg = "Delete Confirmation - \nDelete task : " + $("h5[id*='taskTitle" + taskID + "']").text().trim() + "?\n\nthe task will be deleted permanently."
            return confirm(msg);
        }

        //change class to show selected tab
        function tabChange(tabName) {
            //set for all tabs
            $("input[id*='btnTab']").attr("class", "");
            $("input[id*='btnTab']").addClass("btn nav-link bg-light border");
            //set for selected tab
            $("input[id*='btnTab" + tabName + "']").removeClass("active border");
            $("input[id*='btnTab" + tabName + "']").addClass("active bg-white");

            //show task buttons according to tab
            switch (tabName) {
                case "ToDo":
                    displayActionButtons(["Done", "Edit", "Archive", "Delete"]);  //select buttons for task details of todo task
                    break;
                case "Done":
                    displayActionButtons(["Restore", "Archive", "Delete"]);
                    break;
                case "Archive":
                    displayActionButtons(["Restore", "Delete"]);
                    $("input[id*='btnActionRestore").val($("input[id*='btnActionRestore").val() + " (as ToDo)");
                    break;
            }
        }

        //select which buttons to display at task details buttonNames = [,] array with string names of buttons
        function displayActionButtons(buttonNames) {
            $("input[id*='btnAction']").addClass("d-none");
            $.each(buttonNames, function (i, button) {
                $("input[id*='btnAction" + button + "']").removeClass("d-none");
            });
        }

        //add icon to sort button
        function sortIcon(sortType, sortDirection) {
            $("i[id*='iconSortBy']").attr("class", "");
            if (sortDirection == "Ascending")
                $("#iconSortBy" + sortType).attr("class", "fa fa-angle-double-up");
            else
                $("#iconSortBy" + sortType).attr("class", "fa fa-angle-double-down");
        }

        //change arrow icon on task
        function taskIcon(taskId) {
            $("#taskIcon" + taskId).toggleClass("fa-caret-up");
            $("#taskIcon" + taskId).toggleClass("fa-caret-down");
        }
    </script>

    <style>
        input[id*="btnTab"] {
            border-radius: .25rem .25rem 0 0;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="m-auto p-0" style="max-width: 60rem;">

        <!-- Start edit/new task Modal Dialog -->
        <div class="modal fade" id="editModal" data-backdrop="static" data-keyboard="false">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header center">
                        <asp:TextBox runat="server" ID="mdlTitle" CssClass="modal-title form-control-lg w-50 font-weight-bold align-items-center" Text='title' placeholder="Task Title"></asp:TextBox>
                        <asp:RequiredFieldValidator runat="server" ID="mdlTitleError" ControlToValidate="mdlTitle" ValidationGroup="mdlValitadorGroup" ErrorMessage="Title Required" CssClass="text-danger col mr-0 text-left"></asp:RequiredFieldValidator>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" runat="server" id="mdlContent">
                        <div class="container">
                            <div class="row">
                                <div class="col-3">
                                    <span class="h6">Due Date </span>
                                </div>
                                <div class="col">
                                    <asp:TextBox ID="mdlDueDate" TextMode="date"
                                        CssClass="form-control w-50"
                                        value="2020-05-08"
                                        runat="server" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-3">
                                    <span class="h6">Priority </span>
                                </div>
                                <div class="col form-group m-0">
                                    <asp:DropDownList runat="server" ID="mdlPriority" CssClass="custom-select w-50">
                                        <asp:ListItem Selected="True" Value="1"> 1 - Low </asp:ListItem>
                                        <asp:ListItem Value="2"> 2 - Medium </asp:ListItem>
                                        <asp:ListItem Value="3"> 3 - High </asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <hr />
                        <asp:TextBox ID="mdlDetails"
                            CssClass="form-control form-control-sm"
                            Text='task details'
                            Width="100%"
                            TextMode="MultiLine" Height="100"
                            runat="server" placeholder="Task Details" />
                    </div>
                    <div class="modal-footer" runat="server" id="mdlFooter">
                        <asp:HiddenField ID="mdlID" Value="" runat="server" />
                        <asp:Button ID="btnSave" runat="server"
                            CausesValidation="True" CssClass="btn btn-primary"
                            CommandName="Update" Text="Save" OnClick="btnSave_Click"
                            ValidationGroup="mdlValitadorGroup"></asp:Button>
                        <asp:Button ID="btnCreate" runat="server"
                            CausesValidation="True" CssClass="btn btn-primary"
                            CommandName="Update" Text="Create" OnClick="btnCreate_Click"
                            ValidationGroup="mdlValitadorGroup"></asp:Button>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                        <asp:Label runat="server" ID="mdlMsg" CssClass="text-danger"></asp:Label>
                    </div>
                </div>
            </div>
        </div>
        <!-- END edit/new task Modal Dialog -->

        <!-- Start message after modal -->
        <div class="modal fade" id="msgModal" data-backdrop="true" data-keyboard="true">
            <div class="modal-dialog modal-md" role="document">
                <div class="modal-content">
                    <div class="modal-header modal-body">
                        <h5 class="modal-title">Message</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="modelExit()">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <asp:Label runat="server" ID="mdlMsgSuccess"></asp:Label>
                    </div>
                </div>
            </div>
        </div>
        <!-- END message after modal -->

        <div class="container-fluid row m-auto p-0">
            <div class="col-sm-4 order-first order-sm-2 pt-1 pl-0">
                <!-- Start Summary Tasks -->
                <div class="card mb-3">
                    <div class="card-header">
                        Today Tasks
                    </div>
                    <div class="card-body p-0">
                        <ul class="list-group list-group-flush" id="todayTasksList" runat="server">
                            <asp:Repeater ID="rptTodaySummery" runat="server">
                                <ItemTemplate>
                                    <li class="list-group-item bg-transparent"><%#Eval("Title")%></li>
                                </ItemTemplate>
                                <FooterTemplate>
                                    <asp:Label ID="defaultItem" runat="server" Visible='<%# rptTodaySummery.Items.Count == 0 %>'>
                                        <li class="list-group-item bg-transparent border-0">
                                            No Tasks
                                        </li>
                                    </asp:Label>
                                </FooterTemplate>
                            </asp:Repeater>
                        </ul>
                    </div>
                </div>
                <div class="card mb-3">
                    <div class="card-header">
                        Next Days Tasks
                    </div>
                    <div class="card-body p-0">
                        <ul class="list-group list-group-flush" id="nextDaysTasksList">
                            <asp:Repeater ID="rptNextSummery" runat="server">
                                <ItemTemplate>
                                    <li class="list-group-item bg-transparent"><%#Eval("Title")%></li>
                                </ItemTemplate>
                                <FooterTemplate>
                                    <asp:Label ID="defaultItem" runat="server" Visible='<%# rptNextSummery.Items.Count == 0 %>'>
                                        <li class="list-group-item bg-transparent border-0">
                                            No Tasks
                                        </li>
                                    </asp:Label>
                                </FooterTemplate>
                            </asp:Repeater>
                        </ul>
                    </div>
                </div>
                <!-- End Summary Tasks -->
            </div>
            <div class="col-sm-8 order-last">
                <!-- Start of Tasks Nav Tabs -->
                <div class="overflow-auto row pb-3">
                    <div class="col-9 m-0 p-0 pl-1 border-bottom">
                        <ul class="nav nav-tabs pt-1 border-bottom-0" role="tablist">
                            <li class="nav-item mr-2">
                                <asp:Button runat="server" ID="btnTabToDo" Text="ToDo" CssClass="btn nav-link bg-light border" CommandArgument="ToDo" OnClick="btnTabChange" />
                            </li>
                            <li class="nav-item mr-2">
                                <asp:Button runat="server" ID="btnTabDone" Text="Done" CssClass="btn nav-link bg-light border" CommandArgument="Done" OnClick="btnTabChange" />
                            </li>
                            <li class="nav-item mr-2">
                                <asp:Button runat="server" ID="btnTabArchive" Text="Archive" CssClass="btn nav-link bg-light border" CommandArgument="Archive" OnClick="btnTabChange" />
                            </li>
                        </ul>
                    </div>
                    <div class="col-3 border-bottom order-last p-0 m-0 pt-1 pr-1">
                        <asp:Button type="button" runat="server" ID="btnNewTask" CssClass="btn btn-primary nav-item float-right" Text="New Task" OnClientClick="newTask();return false;" />
                    </div>
                </div>
                <!-- End of Tasks Nav Tabs -->

                <!-- Start of sorting by list + priorities display -->
                <div class="form-group">
                    <label>Sort Task By: </label>

                    <asp:LinkButton CssClass="btn btn-primary btn-sm" runat="server" ID="btnSortByDate" CommandArgument="Date" OnClick="btnTaskSortBy_Click">
                        Date <i id="iconSortByDate"></i>
                    </asp:LinkButton>
                    <asp:LinkButton CssClass="btn btn-primary btn-sm" runat="server" ID="btnSortByTitle" CommandArgument="Title" OnClick="btnTaskSortBy_Click">
                        Title <i id="iconSortByTitle"></i>
                    </asp:LinkButton>
                    <asp:LinkButton CssClass="btn btn-primary btn-sm" runat="server" ID="btnSortByPriority" CommandArgument="Priority" OnClick="btnTaskSortBy_Click">
                        Priority <i id="iconSortByPriority"></i>
                    </asp:LinkButton>
                    <div class="d-inline float-right">
                        Priorities: 
                        <span class="badge badge-info badge-pill p-2">Low</span>
                        <span class="badge badge-warning badge-pill text-white p-2">Medium</span>
                        <span class="badge badge-danger badge-pill p-2">High</span>
                    </div>
                </div>
                <!-- END of sorting by list -->

                <!-- Start of Tasks list -->
                <asp:GridView runat="server" ID="gvData"
                    GridLines="None"
                    AutoGenerateColumns="false"
                    CssClass="table table-sm table-borderless"
                    AllowSorting="true" OnSorting="gvData_Sorting"
                    AllowPaging="true" PageSize="5" OnPageIndexChanging="gvData_OnPageIndexChanging"
                    ShowHeader="False">
                    <Columns>

                        <asp:TemplateField HeaderText="" ItemStyle-VerticalAlign="Top" ItemStyle-Width="40%">
                            <ItemTemplate>
                                <div class="card mb-3">
                                    <div class="card-header <%# Eval("Priority").ToString() == "1" ? "bg-info" : Eval("Priority").ToString() == "2" ? "bg-warning" :"bg-danger" %>" onclick="showTask('<%#Eval("TaskId")%>'); taskIcon(<%#Eval("TaskId")%>);">

                                        <span style="font-size: small; text-align: center">Due To: <b><%# DateTime.Parse(Eval("ToDate").ToString()).ToString("dd-MM-yy") %></b></></span>
                                        <h5 id="taskTitle<%#Eval("TaskId")%>">
                                            <%#Eval("Title")%>
                                            <i id="taskIcon<%#Eval("TaskId")%>" class="fa fa-caret-down float-right"></i>
                                        </h5>
                                    </div>
                                    <div class="card-body bg-light" id="taskDetails<%#Eval("TaskId")%>" style="display: none;">
                                        <p class="card-text"><%#Eval("Details")%></p>
                                        <asp:Button Text="Done" ID="btnActionDone"
                                            CssClass="btn btn-success"
                                            CommandName="DoneTask"
                                            CommandArgument='<%#Eval("TaskId")%>'
                                            runat="server" OnClick="BtnDone_Click" />
                                        <asp:Button Text="Edit" ID="btnActionEdit"
                                            CssClass="btn btn-primary"
                                            CommandName="EditTask"
                                            CommandArgument='<%#Eval("TaskId")%>'
                                            runat="server" OnClick="BtnEdit_Click" />
                                        <asp:Button Text="Restore" ID="btnActionRestore"
                                            CssClass="btn btn-primary"
                                            CommandName="RestoreTask"
                                            CommandArgument='<%#Eval("TaskId")%>'
                                            runat="server" OnClick="BtnRestore_Click" />
                                        <asp:Button Text="Archive" ID="btnActionArchive"
                                            CssClass="btn btn-secondary"
                                            CommandName="ArchiveTask"
                                            CommandArgument='<%#Eval("TaskId")%>'
                                            runat="server" OnClick="BtnArchive_Click" />
                                        <asp:Button Text="Delete" ID="btnActionDelete"
                                            CssClass="btn btn-danger float-right"
                                            CommandName="DeleteTask"
                                            CommandArgument='<%#Eval("TaskId")%>'
                                            runat="server" OnClick="BtnDelete_Click" OnClientClick='<%# "return deleteTask(" + Eval("TaskId") + ");" %>' />
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>

                    <PagerStyle HorizontalAlign="Center" CssClass="pagination" />
                    <PagerSettings Mode="NumericFirstLast" PageButtonCount="3" Position="Bottom" />
                </asp:GridView>
                <!-- END of Tasks list -->
            </div>
        </div>

    </div>

</asp:Content>
