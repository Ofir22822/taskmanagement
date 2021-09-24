<%@ Page Title="Register" Language="C#" AutoEventWireup="true" MasterPageFile="~/Site1.Master" CodeBehind="Register.aspx.cs" Inherits="TaskManagementSystem.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <script>
            $(document).ready(function () {
                if ($(document).attr('title') != "Register")
                    $("#passHide").hide();
            });

        //change password eye icon
            function eyeIcon() {
                console.log($("#passHide").hasClass("fa-eye").toString() == "true");
           if ($("#passHide").hasClass("fa-eye").toString() == "false")
               $("input[id*='userPassword']").attr("type", "text");
           else
               $("input[id*='userPassword']").attr("type", "password");
           $("#passHide").toggleClass("fa-eye");
           $("#passHide").toggleClass("fa-eye-slash");
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">



    <div class="container-fluid h-100" style="border: 0px solid black">
        <div class="row justify-content-center h-100">
            <div class="card-body">
                <div class="card bg-white mb-3 m-auto" style="max-width: 40rem;">
                    <div class="card-header" runat="server" id="cardTitle">Register</div>
                    <div class="card-body">
                        <!--first & last name field!-->
                        <div class="form-group container">
                            <div class="form-group container w-50 float-left">
                                <div class="row">
                                    <label class="col-auto pl-0">First Name</label>
                                    <asp:RequiredFieldValidator runat="server" ID="userFirstNameError" ControlToValidate="userFirstName" ErrorMessage="Required field" CssClass="text-danger col mr-0 text-right"></asp:RequiredFieldValidator>
                                </div>
                                <asp:TextBox runat="server" ID="userFirstName" CssClass="form-control row m-0" placeholder="Enter First Name"></asp:TextBox>
                            </div>
                            <div class="form-group container w-50 float-right">
                                <div class="row">
                                    <label class="col-auto pl-0">Last Name</label>
                                    <asp:RequiredFieldValidator runat="server" ID="userLastNameError" ControlToValidate="userLastName" ErrorMessage="Required field" CssClass="text-danger col mr-0 text-right"></asp:RequiredFieldValidator>
                                </div>
                                <asp:TextBox runat="server" ID="userLastName" CssClass="form-control row m-0" placeholder="Enter Last Name"></asp:TextBox>
                            </div>
                        </div>

                        <!--email field!-->
                        <div class="form-group container">
                            <div class="row">
                                <label class="col-auto pl-0">Email address</label>
                                <asp:RequiredFieldValidator runat="server" ID="userEmailError" ControlToValidate="userEmail" ErrorMessage="Required field" CssClass="text-danger col mr-0 text-right"></asp:RequiredFieldValidator>
                            </div>
                            <asp:TextBox runat="server" ID="userEmail" TextMode="Email" CssClass="form-control row m-0" placeholder="Enter Email"></asp:TextBox>
                        </div>

                        <!--password field!-->
                        <div class="form-group container">
                            <div class="row">
                                <label class="col-auto pl-0">Password <i id="passHide" class="fa fa-eye-slash pl-2 text-black-50" onclick="eyeIcon()"></i></label>
                                <asp:RequiredFieldValidator runat="server" ID="userPasswordError" ControlToValidate="userPassword" ErrorMessage="Required field" CssClass="text-danger col mr-0 text-right"></asp:RequiredFieldValidator>
                            </div>
                            <asp:TextBox runat="server" ID="userPassword" CssClass="form-control d-inline bg-transparent" placeholder="Enter Password"></asp:TextBox>
                        </div>

                        <!--username field!-->
                        <div class="form-group container">
                            <div class="row">
                                <label class="col-auto pl-0">Username</label>
                                <asp:RequiredFieldValidator runat="server" ID="userUsernameError" ControlToValidate="userUsername" ErrorMessage="Required field" CssClass="text-danger col mr-0 text-right"></asp:RequiredFieldValidator>
                            </div>
                            <asp:TextBox runat="server" ID="userUsername" CssClass="form-control row m-0" placeholder="Enter Username"></asp:TextBox>
                        </div>

                        <!--register button + error text + buttons for user info update (same page)!-->
                        <div class="row h-100">
                            <div class="col-12">
                                <asp:Button runat="server" ID="btnCreate" Text="Create User" OnClick="btnCreate_Click" CssClass="btn btn-primary" />
                                <asp:Button runat="server" ID="btnUpdate" Text="Update Details" OnClick="btnUpdate_Click" CssClass="btn btn-primary" />
                                <asp:Label runat="server" ID="registerMsg" CssClass="mt-auto mb-auto text-danger d-inline"></asp:Label>
                                <a href="tasks.aspx" class="btn btn-secondary float-right">Cancel</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
